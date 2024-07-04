//
//  TransactionManagerHomeViewController.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import UIKit
import Combine

class TransactionManagerHomeViewController: UIViewController {
    
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
    
    lazy var logoutButton:UIButton = {
       var button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)), for: .normal)
        button.tintColor = .white
        button.anchor(width: RM.shared.width(40),multiplier: 1)
        button.backgroundColor = AppColors.secondaryColor
        button.layer.cornerRadius = RM.shared.width(40)/2
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    
    
    lazy var transactionListButton:UIButton = {
        var button = UIButton()
        button.setTitle("Transaction List", for: .normal)
        button.backgroundColor = AppColors.secondaryColor
        button.anchor(width: RM.shared.width(250),height: RM.shared.height(40))
        button.layer.cornerRadius = RM.shared.height(10)
        return button
    }()
    
    lazy var chartView:TransactionChartsView = {
       var view = TransactionChartsView()
        view.layer.cornerRadius = RM.shared.height(15)
        view.clipsToBounds = true
        return view
    }()
    
    
    
    
    
    //total income , total expense and current balance view
    lazy var amountVerticalStackView:UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(10)
        return stackView
    }()
    lazy var amountHorizontalStackView:UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(10)
        return stackView
    }()
    
    lazy var totalIncomeAmountView:AmountView = {
        var view = AmountView()
        return view
    }()
    
    lazy var totalExpenseAmountView:AmountView = {
        var view = AmountView()
        return view
    }()
    
    lazy var currentBalanceAmountView:AmountView = {
        var view = AmountView()
        return view
    }()
    
    
    
    
    private var viewModel:TransactionManagerHomeViewModel = .init()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupView()
        viewModel.checkIfDataAvailableInCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    }

}


//MARK: View Binding
extension TransactionManagerHomeViewController {
    
    func cancelAllCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func bindViewModel(){
        
        cancelAllCancellables()
        
        viewModel.$allTransactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactions in
                guard let self = self else {return}
                guard transactions != nil else{return}
                viewModel.prepareDataForBarChart(chartView: chartView.barChartView)
            }
            .store(in: &cancellables)
        
        viewModel.$totalIncome
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalIncome in
                guard let self = self else {return}
                totalIncomeAmountView.setData(amount: String(describing: totalIncome), title: "Total Income", amountColor: AppColors.incomeAmountColor)
            }
            .store(in: &cancellables)
        
        viewModel.$totalExpense
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalExpense in
                guard let self = self else {return}
                totalExpenseAmountView.setData(amount: String(describing: totalExpense), title: "Total Expense", amountColor: AppColors.expenseAmountColor)
            }
            .store(in: &cancellables)
        
        viewModel.$currentBalance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentBalance in
                guard let self = self else {return}
                currentBalanceAmountView.setData(amount: String(describing: currentBalance), title: "Current Balance", amountColor: (currentBalance > 0) ? AppColors.incomeAmountColor : AppColors.expenseAmountColor)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else {return}
                guard let message = errorMessage else {return}
                AlertPresenter().showAlertForError(errorString: message)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
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
        
        authManager?.$isUserLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLogin in
                guard let self = self else {return}
                if !isLogin {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        
    }
    
}


//MARK: View Setup
extension TransactionManagerHomeViewController {
    
    func setupView(){
        addSubViews()
        addActionListeners()
    }
    
    func addSubViews(){
        self.view.backgroundColor = .white
        self.view.addSubview(commonBackgroundView)
        commonBackgroundView.fillSuperview()
        
        self.view.addSubview(customNavigationView)
        customNavigationView.anchor(top: view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor)
        customNavigationView.addSubview(navigationComponentStack)
        navigationComponentStack.fillSuperview(padding: .init(top: 0, left: RM.shared.width(10), bottom: 0, right: RM.shared.width(10)))
        
        navigationComponentStack.addArrangedSubview(viewControllerTitleLabel)
        navigationComponentStack.addArrangedSubview(logoutButton)
        
        self.view.addSubview(transactionListButton)
        transactionListButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: RM.shared.height(30))
        transactionListButton.centerX(inView: self.view)
        
        self.view.addSubview(chartView)
        chartView.anchor(top: customNavigationView.bottomAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor,paddingTop: RM.shared.height(10),paddingLeading: RM.shared.height(10),paddingTrailing: RM.shared.height(10),height: RM.shared.height(300))
        
        self.view.addSubview(amountVerticalStackView)
        amountVerticalStackView.anchor(top: chartView.bottomAnchor,leading: chartView.leadingAnchor,trailing: chartView.trailingAnchor,paddingTop:RM.shared.height(10))
        
        amountVerticalStackView.addArrangedSubview(amountHorizontalStackView)
        amountVerticalStackView.addArrangedSubview(currentBalanceAmountView)
        
        amountHorizontalStackView.addArrangedSubview(totalIncomeAmountView)
        amountHorizontalStackView.addArrangedSubview(totalExpenseAmountView)
        
        
    }
    
    
    //MARK: Action Listeners and methods
    func addActionListeners(){
        transactionListButton.addTarget(self, action: #selector(transactionListButtonAction(_:)), for: .touchUpInside)
    }
    
    //present transaction list
    @objc func transactionListButtonAction(_ sender:UIButton){
        let transactionListViewController = TransactionListViewController()
        transactionListViewController.viewModel = self.viewModel
        self.navigationController?.pushViewController(transactionListViewController, animated: true)
    }
    
    //logout from session
    @objc func logout(){
        self.presentAlertWithTitle(title: "Logout", message: "Do you want to logout", options: "Yes","No") { options in
            switch options{
            case 0:
                self.viewModel.logoutFireBase()
            default:
                break
            }
        }
    }
}

