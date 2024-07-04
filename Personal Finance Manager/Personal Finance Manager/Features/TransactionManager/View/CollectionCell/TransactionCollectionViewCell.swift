//
//  TransactionCollectionViewCell.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import UIKit
import FirebaseFirestore

class TransactionCollectionViewCell: UICollectionViewCell {
    
    static var identifier:String = "TransactionCollectionViewCell"
    
    //MARK: Components
    
    private lazy var baseView:UIView = {
       var view  = UIView()
        view.backgroundColor = AppColors.secondaryColor
        return view
    }()
    
    private lazy var mainStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = RM.shared.height(10)
        return stackView
    }()
    
    
    //Date view components
    private lazy var calenderBaseView:UIView = {
       var view = UIView()
        view.backgroundColor = .white
        view.anchor(width: RM.shared.width(80),multiplier: 1)
        return view
    }()
    
    private lazy var dateStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = RM.shared.height(3)
        return stackView
    }()
    
    private lazy var dateLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12"
        label.textColor = AppColors.expenseAmountColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var monthLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "july"
        label.textColor = AppColors.expenseAmountColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var YearLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2024"
        label.textColor = AppColors.expenseAmountColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    //other components
    
    private lazy var verticalStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(10)
        return stackView
    }()
    
    private lazy var titleAmountStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.width(10)
        return stackView
    }()
    
    private lazy var titleLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The standard Lorem Ipsum passage"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var amountLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+13$"
        label.textColor = AppColors.expenseAmountColor
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var categoryNotesStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = RM.shared.height(10)
        return stackView
    }()
    
    private lazy var categoryLabel:PaddingLabel = {
       var label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Grocery"
        label.textColor = AppColors._eec1b7
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        return label
    }()
    
    private lazy var optionalNotesLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock"
        label.textColor = AppColors._e6e6e6
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var deleteButton:UIButton = {
       var button = UIButton()
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.tintColor = AppColors.expenseAmountColor
        button.anchor(width: RM.shared.width(40),multiplier: 1)
        return button
    }()
    
    
    //MARK: Properties
    open weak var delegate:TransactionCollectionViewCellProtocol?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func prepareForReuse() {
        delegate = nil
    }
}

//MARK: View Setup
extension TransactionCollectionViewCell {
    
    func setupView(){
        addSubViews()
        addActionListeners()
    }
    
    func addSubViews(){
        self.backgroundColor = .clear
        
        self.addSubview(baseView)
        baseView.fillSuperview(padding: .init(top: RM.shared.height(8), left: RM.shared.height(8), bottom: RM.shared.height(8), right: RM.shared.height(8)))
        baseView.addSubview(mainStackView)
        mainStackView.fillSuperview(padding: .init(top: RM.shared.height(8), left: RM.shared.height(8), bottom: RM.shared.height(8), right: RM.shared.height(8)))
    
        mainStackView.addArrangedSubview(calenderBaseView)
        calenderBaseView.addSubview(dateStackView)
        dateStackView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(monthLabel)
        dateStackView.addArrangedSubview(YearLabel)
    
        mainStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleAmountStackView)
        
        titleAmountStackView.addArrangedSubview(titleLabel)
        titleAmountStackView.addArrangedSubview(amountLabel)
        
        verticalStackView.addArrangedSubview(categoryNotesStackView)
        categoryNotesStackView.addArrangedSubview(categoryLabel)
        categoryNotesStackView.addArrangedSubview(optionalNotesLabel)
        
        mainStackView.addArrangedSubview(deleteButton)
    }
    
    func addActionListeners(){
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    
    @objc func deleteAction(){
        self.delegate?.didTapDeleteAction(cell: self)
    }
    
    func setViewWithData(transaction:TransactionModel){
        
        self.titleLabel.text = transaction.title
        let transactionType = TransactionType(rawValue: transaction.transactionType ?? "empty")
        switch transactionType {
        case .income:
            self.amountLabel.text = "+ $"+(transaction.amount ?? "0")
            self.amountLabel.textColor = AppColors.incomeAmountColor
        case .expense:
            self.amountLabel.text = "- $"+(transaction.amount ?? "0")
            self.amountLabel.textColor = AppColors.expenseAmountColor
        case nil:
            self.amountLabel.text = "0"
            self.amountLabel.textColor = .red
        }
        
        self.categoryLabel.text = transaction.category
        self.optionalNotesLabel.text = transaction.note
        
        
        
        if let date = transaction.date{
            let (dayString, monthString, year) = date.dateValue().dayMonthYearString()
            self.dateLabel.text = dayString
            self.monthLabel.text = monthString
            self.YearLabel.text = String(describing: year)
        }else{
            self.dateLabel.text = "-"
            self.monthLabel.text = "-"
            self.YearLabel.text = "-"
        }
        
    }
}
