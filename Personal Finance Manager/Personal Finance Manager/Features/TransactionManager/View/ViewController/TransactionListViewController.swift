//
//  TransactionListViewController.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import UIKit
import Combine

class TransactionListViewController: UIViewController {
     
    //MARK: Components
    lazy var commonBackgroundView:CommonBackGroundView = {
       var view = CommonBackGroundView()
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    
    //top navigation view
    lazy var customNavigationView:UIView = {
        var view  = UIView()
        return view
    }()
    
    lazy var navigationComponentStack:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.width(10)
        return stackView
    }()
    

    lazy var viewControllerTitleLabel:UILabel = {
        var label = UILabel()
        label.text = "Transaction List"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var backButton:UIButton = {
       var button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)), for: .normal)
        button.tintColor = .white
        button.anchor(width: RM.shared.width(40),multiplier: 1)
        button.backgroundColor = AppColors.secondaryColor
        button.layer.cornerRadius = RM.shared.width(40)/2
        return button
    }()
    

    lazy var createTransactionButton:UIButton = {
       var button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)), for: .normal)
        button.tintColor = .white
        button.anchor(width: RM.shared.width(40),multiplier: 1)
        button.backgroundColor = AppColors.secondaryColor
        button.layer.cornerRadius = RM.shared.width(40)/2
        return button
    }()
    
    lazy var transactionsEntryView:TransactionsEntryView = {
       var view = TransactionsEntryView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    
    lazy var segmentAndFilterView:SegmentAndFilterView = {
        var view = SegmentAndFilterView(titles: [TransactionType.income.rawValue.uppercased(),TransactionType.expense.rawValue.uppercased()])
        view.delegate = self
        return view
    }()
    
    
    //collectionview
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        return collectionView
    }()
    
    //filter
    
    lazy var filterView:FilterOptionsView = {
       var view = FilterOptionsView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    
    
    //MARK: properties
    var viewModel:TransactionManagerHomeViewModel?
    private typealias DataSource = UICollectionViewDiffableDataSource<TransactionListSection<AnyHashable>, AnyHashable>
    private var dataSource: DataSource?
    private let layout = CollectionViewLayoutBuilder()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage:Int = 1{
        didSet{
            switch currentPage {
                case 1:
                segmentAndFilterView.setButtonSelectedAt(index: 0)
                case 2:
                segmentAndFilterView.setButtonSelectedAt(index: 1)
                default:
                    break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupView()
       
    }
    
    deinit {
        print("Done")
    }
}

//MARK: View Setup
extension TransactionListViewController {
    
    func setupView(){
        addSubViews()
        addActionListeners()
    }
    
    func addSubViews(){
        self.view.backgroundColor = .white
        self.view.addSubview(commonBackgroundView)
        commonBackgroundView.fillSuperview()

        self.view.addSubview(transactionsEntryView)
        transactionsEntryView.fillSuperview()
        
        
        self.view.addSubview(customNavigationView)
        customNavigationView.anchor(top: view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor)
        customNavigationView.addSubview(navigationComponentStack)
        navigationComponentStack.fillSuperview(padding: .init(top: 0, left: RM.shared.width(10), bottom: 0, right: RM.shared.width(10)))
        
        navigationComponentStack.addArrangedSubview(backButton)
        navigationComponentStack.addArrangedSubview(viewControllerTitleLabel)
        navigationComponentStack.addArrangedSubview(createTransactionButton)
        
        self.view.addSubview(segmentAndFilterView)
        segmentAndFilterView.anchor(top: customNavigationView.bottomAnchor,leading: self.view.leadingAnchor,trailing: view.trailingAnchor,paddingTop: RM.shared.height(20))
        
        self.view.addSubview(collectionView)
        collectionView.anchor(top: segmentAndFilterView.bottomAnchor,leading: view.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,trailing: view.trailingAnchor,paddingTop: RM.shared.height(10))
        
        self.view.addSubview(filterView)
        filterView.fillSuperview()
        
    
        self.view.bringSubviewToFront(customNavigationView)
        self.view.bringSubviewToFront(transactionsEntryView)
        
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: TransactionCollectionViewCell.identifier)
        collectionView.collectionViewLayout = makeLayout()
        collectionView.delegate = self
        setupCollectionViewDataSource()
    }
    
    
    //MARK: Buttons action adding
    func addActionListeners(){
        createTransactionButton.addTarget(self, action: #selector(createTransactionAction(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
    }

    @objc func createTransactionAction(_ sender:UIButton){
        transactionsEntryView.isHidden = !transactionsEntryView.isHidden
    }
    
    @objc func backButtonAction(_ sender:UIButton){
        self.viewModel = nil
        self.dataSource = nil
        self.viewModel?.sectionData = nil
        cancelAllCancellables()
        self.navigationController?.popViewController(animated: true)
    }
}



//MARK: View Binding
extension TransactionListViewController {
    
    func cancelAllCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func bindViewModel(){
        
        viewModel?.$allTransactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactions in
                guard let self = self else {return}
                guard let transactions = transactions else{return}
                print("Trans")
                viewModel?.buildSections()
            }
            .store(in: &cancellables)
        
        viewModel?.$sectionData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sectionData in
                guard let self = self else {return}
                guard let sectionData = sectionData else {return}
                segmentAndFilterView.isUserInteractionEnabled = !sectionData.isEmpty
                self.applyData(sectionData: sectionData)
            }
            .store(in: &cancellables)
        
        viewModel?.$transactionDeleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactionDeleted in
                guard let self = self else {return}
                if let isDeleted = transactionDeleted , isDeleted == true {
                    viewModel?.fetchAllTransactionList()
                    viewModel?.transactionDeleted = false
                }
            }
            .store(in: &cancellables)
        
        viewModel?.$transactionAdded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactionAdded in
                guard let self = self else {return}
                if let isAdded = transactionAdded , isAdded == true {
                    transactionsEntryView.isHidden = true
                    viewModel?.fetchAllTransactionList()
                    AlertPresenter().showAlertForSuccss(successString: "Transaction added successfully")
                    viewModel?.transactionAdded  = false
                }
            }
            .store(in: &cancellables)
        
        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard self != nil else {return}
                guard let message = errorMessage else {return}
                AlertPresenter().showAlertForError(errorString: message)
            }
            .store(in: &cancellables)
        
        viewModel?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else {return}
                guard let isLoading = isLoading else {return}
                switch isLoading {
                case true:
                    self.view.activityStartAnimating()
                case false:
                    self.view.activityStopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
}

//MARK: Collectionview Layout
extension TransactionListViewController {
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else {return nil}
            
            let sectionLayout = self.layout.verticalListLayout()
            return sectionLayout
            
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout
    }
}

//MARK: Collectionview Data Source
extension TransactionListViewController {
    
    private func applyData(sectionData:[TransactionListSection<AnyHashable>]) {
        var snapshot = NSDiffableDataSourceSnapshot<TransactionListSection<AnyHashable>, AnyHashable>()
        sectionData.forEach { section in
            guard !section.items.isEmpty else { return }
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        if let sectionIdentifiers = dataSource?.snapshot().sectionIdentifiers{
            if sectionIdentifiers.count > 1 {
                segmentAndFilterView.userInterectionforAllSegment(dsable: false)
            }else {
                segmentAndFilterView.userInterectionforAllSegment(dsable: true)
                switch sectionIdentifiers.first?.sectionType {
                case .income:
                    self.currentPage = 1
                    break
                case .expense:
                    self.currentPage = 2
                    break
                default:
                    break
                }
            }
        
        }
    }
    
    private func updateData(incomeTransactions: [TransactionModel],expenseTransactions: [TransactionModel]){
        var snapShot = dataSource?.snapshot()
        guard let sections = snapShot?.sectionIdentifiers else {return}
        for section in sections {
            switch section.sectionType {
            case .income:
                snapShot?.deleteItems(sections)
                snapShot?.appendItems(incomeTransactions, toSection: section)
                dataSource?.apply(snapShot!,animatingDifferences: true)
                break
            case .expense:
                snapShot?.deleteItems(sections)
                snapShot?.appendItems(incomeTransactions, toSection: section)
                dataSource?.apply(snapShot!,animatingDifferences: true)
                break
            }
        }
  
    }
    
    
    func setupCollectionViewDataSource() {
        //For Regular Cell
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.identifier, for: indexPath) as? TransactionCollectionViewCell else {return UICollectionViewCell()}
            
            cell.delegate = self
            if let item = itemIdentifier as? TransactionModel {
                cell.setViewWithData(transaction: item)
            }
            
            return cell
        })
        
    }
}


//MARK: scrollViewDidScroll
extension TransactionListViewController:UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let sectionData = self.viewModel?.sectionData else {return}
        
        let visibleBounds = collectionView.bounds
        let collectionViewSize = collectionView.contentSize
        
        let pageWidth = collectionViewSize.width / CGFloat(sectionData.count)
        let currentPage = Int((visibleBounds.origin.x + visibleBounds.size.width / 2) / pageWidth) + 1
        
        if self.currentPage != currentPage{
            self.currentPage = currentPage
        }
        print(currentPage)
    }
}


//MARK: TransactionsEntryViewProtocol
extension TransactionListViewController:TransactionsEntryViewProtocol{
    func didAddTransactionData(transaction: TransactionModel) {
        self.viewModel?.createTransaction(transaction: transaction)
    }
}

//MARK: TransactionCollectionViewCellProtocol
extension TransactionListViewController:TransactionCollectionViewCellProtocol{
    func didTapDeleteAction(cell: TransactionCollectionViewCell?) {
        guard let cell = cell else {return}
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        if let tranactionItem = dataSource?.itemIdentifier(for: indexPath) as? TransactionModel{
            guard let documentID = tranactionItem.id else {return}
            
            //alert presenter for to be sure about delete
            self.presentAlertWithTitle(title: "Delete", message: "Delete transaction?", options: "Yes","No") { options in
                switch options{
                case 0:
                    self.viewModel?.deleteTransaction(documentID: documentID)
                    break
                case 1:
                    break
                default:
                    break
                }
            }
        }
    }
}

//MARK: SegmentAndFilterViewProtocol
extension TransactionListViewController:SegmentAndFilterViewProtocol {
    func didTapFilterButton() {
        filterView.isHidden = !filterView.isHidden
        filterView.setTransactionCategoryMenu(sender: filterView.selecCategoryButton, items: (segmentAndFilterView.selectedIndex == 0) ? TransactionType.income.category : TransactionType.expense.category )
        
        filterView.setValueWithFilter(filter: (segmentAndFilterView.selectedIndex == 0) ? self.viewModel?.incomeFiler : self.viewModel?.expenseFiler)
    }
    
    func didSelectSegment(index: Int) {
        if let sectionCount = dataSource?.snapshot().numberOfSections,sectionCount > 0{
            collectionView.scrollToItem(at: IndexPath(item: 0, section: index), at: .top, animated: true)
        }
    }
}

//MARK: FilterOptionsViewProtocol
extension TransactionListViewController:FilterOptionsViewProtocol{
    func didTapClearAllFilter() {
        switch segmentAndFilterView.selectedIndex{
        case 0:
            self.viewModel?.incomeFiler = nil
        default:
            self.viewModel?.expenseFiler = nil
        }
        
        self.viewModel?.applyFilters()
        self.viewModel?.buildSections()
        
    }
    
    func didTapApplyFilter(filter: TransactionFilterModel) {
        switch segmentAndFilterView.selectedIndex{
        case 0:
            self.viewModel?.incomeFiler = filter
        default:
            self.viewModel?.expenseFiler = filter
        }
        
        self.viewModel?.applyFilters()
        self.viewModel?.buildSections()
        
//        if let viewModel = viewModel {
//            self.updateData(incomeTransactions: viewModel.incomeTransactions, expenseTransactions: viewModel.expenseTransactions)
//        }
        
        
    }
}
