//
//  FilterView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation
import UIKit
import FirebaseFirestore

class FilterOptionsView:UIView{
    
    //MARK: Components
    
    lazy var baseView:UIView =  {
       var view = UIView()
        view.backgroundColor = AppColors._933d65
        view.layer.cornerRadius = 6
        return view
    }()
    
    
    lazy var baseStack:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.width(10)
        return stackView
    }()
    
    
    //date filter
    lazy var datePickerTitle:UILabel = {
       var label =  UILabel()
        label.text = "Select date: "
        label.textColor = .white
        return label
    }()
    
    lazy var datePicker:UIDatePicker = {
        var picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.anchor(height: RM.shared.height(100))
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    
    //amount filter
    lazy var amountTitle:UILabel = {
       var label =  UILabel()
        label.text = "Enter amount range "
        label.textColor = .white
        return label
    }()
    
    lazy var amountStack:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = RM.shared.width(10)
        return stackView
    }()
    
    
    lazy var fromAmountField:UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "From",
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
    
    lazy var toAmountField:UITextField = {
        var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "To",
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
    
    
    //category filter
    lazy var categoryFilterTitle:UILabel = {
       var label =  UILabel()
        label.text = "Category"
        label.textColor = .white
        return label
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
    
    
    lazy var applyButton:UIButton = {
        var button = UIButton()
        button.setTitle("Apply filter", for: .normal)
        button.setTitleColor(AppColors.primaryColor, for: .normal)
        button.titleEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(applyFilterAction), for: .touchUpInside)
        button.layer.cornerRadius = 6
        return button
    }()
    
    lazy var clearAllFilterButton:UIButton = {
        var button = UIButton()
        button.setTitle("Clear all filter", for: .normal)
        button.setTitleColor(AppColors.primaryColor, for: .normal)
        button.titleEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(clearFilterAction), for: .touchUpInside)
        button.layer.cornerRadius = 6
        return button
    }()
    
    
    //MARK: Properties
    open weak var delegate:FilterOptionsViewProtocol?
    var filter:TransactionFilterModel = .init()
    var selectedDate:Date?
    
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


//MARK: Setup UI
extension FilterOptionsView{
    func setUI(){
        self.backgroundColor = .black.withAlphaComponent(0.5)

        self.addSubview(baseView)
        baseView.anchor(leading: self.leadingAnchor,trailing: self.trailingAnchor,paddingLeading: RM.shared.height(10),paddingTrailing: RM.shared.height(10))
        baseView.centerY(inView: self)
        
        baseView.addSubview(baseStack)
        baseStack.fillSuperview(padding: .init(top: RM.shared.height(10), left: RM.shared.height(10), bottom: RM.shared.height(10), right: RM.shared.height(10)))
        
        baseStack.addArrangedSubview(datePickerTitle)
        baseStack.addArrangedSubview(datePicker)
        
        baseStack.addArrangedSubview(amountTitle)
        baseStack.addArrangedSubview(amountStack)
        amountStack.addArrangedSubview(fromAmountField)
        amountStack.addArrangedSubview(toAmountField)
        
        baseStack.addArrangedSubview(categoryFilterTitle)
        baseStack.addArrangedSubview(selecCategoryButton)
        baseStack.addArrangedSubview(applyButton)
        baseStack.addArrangedSubview(clearAllFilterButton)
        
        addGestures()
        
    }
    
    //MARK: Transaction Category menu adding
    func setTransactionCategoryMenu(sender:UIButton,items:[String]){
        var actionSet = [UIAction]()
        for item in items {
            actionSet.append(UIAction(title: item){ [weak self] _ in
                guard let self = self else {return}
                sender.setTitle(item, for: .normal)
                self.filter.category = item
            })
        }
        if !actionSet.isEmpty {
            sender.menu = UIMenu(title: "Transaction Category", options: .displayInline, children: actionSet)
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
    
    //MARK: set view components value if filter is applied
    func setValueWithFilter(filter:TransactionFilterModel?){
        guard let filter = filter else {
            resetValue()
            return}
        
        if let date = filter.date {
            self.datePicker.date = date.dateValue()
        }else{
            self.datePicker.date = Date()
        }
        
        if let range = filter.range , let from = range.from,let to = range.to{
            self.fromAmountField.text = String(describing: from)
            self.toAmountField.text = String(describing: to)
        }else{
            self.fromAmountField.text?.removeAll()
            self.toAmountField.text?.removeAll()
        }
        
        if let category = filter.category {
            self.selecCategoryButton.setTitle(category, for: .normal)
        }else{
            self.selecCategoryButton.setTitle("Select Category", for: .normal)
        }
    }
    
    func addGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: reset view components value
    func resetValue(){
        self.datePicker.date = Date()
        self.fromAmountField.text?.removeAll()
        self.toAmountField.text?.removeAll()
        self.selecCategoryButton.setTitle("Select Category", for: .normal)
    }
    
    
    
    
    //MARK: Action listeners
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    @objc func applyFilterAction(){
        
        if let date = self.selectedDate {
            filter.date = Timestamp(date: date)
        }
        
        if let fromAmount = fromAmountField.text,!fromAmount.trimmingCharacters(in: .whitespaces).isEmpty,
           let toAmount = toAmountField.text , !toAmount.trimmingCharacters(in: .whitespaces).isEmpty{
            
            filter.range = .init(from: Double(fromAmount),to: Double(toAmount))
        }
        
        if filter.date == nil && filter.range == nil && filter.category == nil{
            print("No filter selected")
            return
        }
        
        self.delegate?.didTapApplyFilter(filter: filter)
    }
    
    @objc func clearFilterAction(){
        filter = .init()
        self.resetValue()
        self.delegate?.didTapClearAllFilter()
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.isHidden = true
    }
}
