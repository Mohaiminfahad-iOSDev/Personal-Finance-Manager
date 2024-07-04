//
//  AmountView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import UIKit

class AmountView: UIView {

    //MARK: Components
    lazy var mainStackView:UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = RM.shared.height(15)
        return stackView
    }()
    
    lazy var amountLabel:UILabel = {
       var label =  UILabel()
        label.text = "$0"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize:20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var titleLabel:UILabel = {
       var label =  UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize:18)
        return label
    }()

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
extension AmountView {
    func setUI(){
        self.backgroundColor = AppColors.secondaryColor
        self.layer.cornerRadius = RM.shared.height(10)
        addSubViews()
    }
    
    func addSubViews(){
        self.addSubview(mainStackView)
        mainStackView.fillSuperview(padding: .init(top: RM.shared.height(20), left: RM.shared.height(30), bottom: RM.shared.height(20), right: RM.shared.height(30)))
        mainStackView.addArrangedSubview(amountLabel)
        mainStackView.addArrangedSubview(titleLabel)
    }
    
    func setData(amount:String,title:String,amountColor:UIColor){
        self.amountLabel.text = amount+"$"
        self.titleLabel.text = title
        self.amountLabel.textColor = amountColor
    }
}
