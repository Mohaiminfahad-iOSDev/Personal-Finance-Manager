//
//  TransactionsEntryView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import UIKit
import FirebaseFirestore

class TransactionsEntryView: UIView {
    
    //MARK: Components
    lazy var closeButton:UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)), for: .normal)
        button.tintColor = .white
        button.anchor(width: RM.shared.width(50),multiplier: 1)
        button.backgroundColor = AppColors.secondaryColor
        button.layer.cornerRadius = RM.shared.width(50)/2
        return button
    }()
    
    lazy var baseView:UIView = {
        var view = UIView()
        view.backgroundColor = AppColors.secondaryColor
        return view
    }()
    
    lazy var mainStackView:UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(15)
        return stackView
    }()
    
    lazy var selecTransactionTypeButton:UIButton = {
        var button = UIButton()
        button.setTitle("Select Transaction Type", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var titleField:UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.anchor(width: RM.shared.width(UIScreen.main.bounds.width*0.7),height: RM.shared.height(50))
        textField.textColor = .white
        textField.backgroundColor = .white.withAlphaComponent(0.5)
        textField.setLeftPaddingPoints(RM.shared.width(10))
        textField.layer.cornerRadius = RM.shared.width(10)
        return textField
    }()
    
    lazy var amountField:UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Amount",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.anchor(width: RM.shared.width(UIScreen.main.bounds.width*0.7),height: RM.shared.height(50))
        textField.textColor = .white
        textField.backgroundColor = .white.withAlphaComponent(0.5)
        textField.setLeftPaddingPoints(RM.shared.width(10))
        textField.layer.cornerRadius = RM.shared.width(10)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var selecCategoryButton:UIButton = {
        var button = UIButton()
        button.setTitle("Select Category", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var optionalNotesTitle:UILabel = {
        var label = UILabel()
        label.text = "Notes (Optional)"
        label.textColor = .white
        return label
    }()
    
    lazy var optionalNotesTextView:UITextView = {
        var textView = UITextView()
        textView.anchor(height: RM.shared.height(100))
        textView.textColor = .white
        textView.backgroundColor = .white.withAlphaComponent(0.5)
        textView.layer.cornerRadius = RM.shared.width(10)
        textView.isScrollEnabled = true
        return textView
    }()
    
    lazy var addTransactionButton:UIButton = {
        var button = UIButton()
        button.setTitle("Add", for: .normal)
        button.titleEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitleColor(AppColors.secondaryColor, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var datePickerStackView:UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(15)
        return stackView
    }()
    
    
    lazy var datePickerTitle:UILabel = {
       var label =  UILabel()
        label.text = "Select date: "
        label.textColor = .white
        return label
    }()
    
    lazy var datePicker:UIDatePicker = {
        var picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.anchor(height: RM.shared.height(100))
        return picker
    }()
    
    //MARK: -
    var singleTransaction:TransactionModel = .init()
    weak var delegate:TransactionsEntryViewProtocol?
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
}


//MARK: Set UI
extension TransactionsEntryView {
    func setUI(){
        addSubViews()
        addActionListeners()
        setTransactionTypesMenu(sender: selecTransactionTypeButton, items: [TransactionType.income,TransactionType.expense])
    }
    func addSubViews(){
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.addSubview(closeButton)
        closeButton.anchor(top: self.topAnchor,trailing: self.trailingAnchor,paddingTop: RM.shared.height(20),paddingTrailing: RM.shared.width(20))
        
        self.addSubview(baseView)
        baseView.centerX(inView: self)
        baseView.centerY(inView: self)
        
        baseView.addSubview(mainStackView)
        mainStackView.fillSuperview(padding: .init(top: RM.shared.height(10), left: RM.shared.width(10), bottom: RM.shared.height(10), right: RM.shared.width(10)))
        
        mainStackView.addArrangedSubview(selecTransactionTypeButton)
        mainStackView.addArrangedSubview(titleField)
        mainStackView.addArrangedSubview(amountField)
        mainStackView.addArrangedSubview(datePickerStackView)
        
        datePickerStackView.addArrangedSubview(datePickerTitle)
        datePickerStackView.addArrangedSubview(datePicker)
        
        mainStackView.addArrangedSubview(selecCategoryButton)
        mainStackView.addArrangedSubview(optionalNotesTitle)
        mainStackView.addArrangedSubview(optionalNotesTextView)
        mainStackView.addArrangedSubview(addTransactionButton)
        
    }
    func addActionListeners(){
        closeButton.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransactionAction), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func closeAction(_ sender:UIButton){
        isHidden = !isHidden
    }
    @objc func addTransactionAction(_ sender:UIButton){
        fieldValidation()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let timestamp = Timestamp(date: sender.date)
        self.singleTransaction.date = timestamp
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateString = dateFormatter.string(from: timestamp.dateValue())
//        print(dateString)
    }
    
    
    //MARK: Transaction type menu adding
    func setTransactionTypesMenu(sender:UIButton,items:[TransactionType]){
        var actionSet = [UIAction]()
        for item in items {
            actionSet.append(UIAction(title: item.rawValue){ [weak self] _ in
                guard let self = self else {return}
                sender.setTitle(item.rawValue, for: .normal)
                self.singleTransaction.transactionType = item.rawValue
                self.singleTransaction.category = nil
                self.selecCategoryButton.setTitle("Select Category", for: .normal)
                self.setTransactionCategoryMenu(sender: self.selecCategoryButton, items: item.category)
                print(self.singleTransaction)
            })
        }
        if !actionSet.isEmpty {
            sender.menu = UIMenu(title: "Transaction Type", options: .displayInline, children: actionSet)
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
    //MARK: Transaction Category menu adding
    func setTransactionCategoryMenu(sender:UIButton,items:[String]){
        var actionSet = [UIAction]()
        for item in items {
            actionSet.append(UIAction(title: item){ [weak self] _ in
                guard let self = self else {return}
                sender.setTitle(item, for: .normal)
                self.singleTransaction.category = item
                print(self.singleTransaction)
            })
        }
        if !actionSet.isEmpty {
            sender.menu = UIMenu(title: "Transaction Category", options: .displayInline, children: actionSet)
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
}


//MARK: Validation
extension TransactionsEntryView {
    
    func fieldValidation(){
        if self.singleTransaction.transactionType == nil{
            print("select transaction type")
            AlertPresenter().showAlertForError(errorString: "select transaction type")
            return
        }
        
        guard let title = titleField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Enter title")
            AlertPresenter().showAlertForError(errorString: "Enter title")
            return
        }
        
        self.singleTransaction.title = title
        
        guard let amount = amountField.text, !amount.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Enter amount")
            AlertPresenter().showAlertForError(errorString: "Enter amount")
            return
        }
        self.singleTransaction.amount = amount
        
        if self.singleTransaction.date == nil {
            print("select date")
            AlertPresenter().showAlertForError(errorString: "select date")
            return
        }
        
        if self.singleTransaction.category == nil {
            print("select transaction category")
            AlertPresenter().showAlertForError(errorString: "select transaction category")
            return
        }
        
        self.singleTransaction.note = optionalNotesTextView.text
        
        
        self.delegate?.didAddTransactionData(transaction: self.singleTransaction)
  
    }
    
}
