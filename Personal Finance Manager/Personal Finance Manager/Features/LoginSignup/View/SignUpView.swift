//
//  SignUpView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 29/6/24.
//

import Foundation
import UIKit

class SignUpView:UIView{
    
    
    //MARK: Components
    
    lazy var mainStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = RM.shared.height(30)
        return stackView
    }()
    
    lazy var baseView:UIView = {
       var view = UIView()
        return view
    }()
    
    
    lazy var visualEffectBack:BlurEffectView = {
       var blurView = BlurEffectView()
        return blurView
    }()
 
    lazy var verticalBaseStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(30)
        return stackView
    }()
    
    lazy var verticalStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(5)
        return stackView
    }()
    
    
    lazy var signupTitle:UILabel = {
       var label = UILabel()
        label.text = "Sign Up"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 45)

        return label
    }()
    
    lazy var emailField:UITextField = {
       var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.anchor(width: RM.shared.width(UIScreen.main.bounds.width*0.7),height: RM.shared.height(50))
        textField.textColor = .white
        textField.backgroundColor = .white.withAlphaComponent(0.5)
        textField.setLeftPaddingPoints(RM.shared.width(10))
        textField.layer.cornerRadius = RM.shared.width(10)
        return textField
    }()
    
    lazy var passwordField:UITextField = {
       var textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.anchor(height: RM.shared.height(50))
        textField.textColor = .white
        textField.backgroundColor = .white.withAlphaComponent(0.5)
        textField.setLeftPaddingPoints(RM.shared.width(10))
        textField.layer.cornerRadius = RM.shared.width(10)
        return textField
    }()
    
    lazy var signupButton:UIButton = {
       var button = UIButton()
        button.setTitle("Signup", for: .normal)
        button.setTitleColor(AppColors.primaryColor, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = RM.shared.height(10)
        button.anchor(width: RM.shared.width(100),height: RM.shared.height(35))
        button.tag = 3
        return button
    }()
    
    lazy var bottomStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.height(10)
        return stackView
    }()
    
    lazy var haveAccountLabel:UILabel = {
       var label = UILabel()
        label.text = "Already have account?"
        label.textColor = .white
        return label
    }()
    
    lazy var signinButton:UIButton = {
       var button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tag = 4
        return button
    }()
    
    //MARK: properties
    weak var delegate:LoginSignupViewProtocol?
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        baseView.layer.borderColor = UIColor.white.cgColor
        baseView.layer.borderWidth = 1
        baseView.layer.cornerRadius = RM.shared.height(20)
        baseView.clipsToBounds = true
    }
}

//MARK: Set UI
extension SignUpView {
    func setUI(){
        addSubViews()
        addActionListeners()
    }
    
    func addSubViews(){
        
        self.addSubview(mainStackView)
        mainStackView.fillSuperview()

        mainStackView.addArrangedSubview(baseView)
        
        baseView.addSubview(visualEffectBack)
        visualEffectBack.fillSuperview()
        
        baseView.addSubview(verticalBaseStackView)
        
        verticalBaseStackView.fillSuperview(padding: .init(top: RM.shared.width(10), left: RM.shared.width(10), bottom: RM.shared.width(10), right: RM.shared.width(10)))
        
        verticalBaseStackView.addArrangedSubview(signupTitle)
        verticalBaseStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(emailField)
        verticalStackView.addArrangedSubview(passwordField)
        
        mainStackView.addArrangedSubview(signupButton)
        mainStackView.addArrangedSubview(bottomStackView)
        
        bottomStackView.addArrangedSubview(haveAccountLabel)
        bottomStackView.addArrangedSubview(signinButton)
    }
    
    func addActionListeners(){
        signinButton.addTarget(self, action: #selector(siginAction(_:)), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(sigupAction(_:)), for: .touchUpInside)
    }
    
    
    @objc func siginAction(_ sender:UIButton){
        self.delegate?.didTapSiginInButton(sender)
    }
    
    @objc func sigupAction(_ sender:UIButton){
        self.delegate?.didTapSignUpButotn(sender)
    }
    
}



