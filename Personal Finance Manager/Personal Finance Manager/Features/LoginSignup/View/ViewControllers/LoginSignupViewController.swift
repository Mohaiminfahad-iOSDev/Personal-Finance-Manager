//
//  ViewController.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 27/6/24.
//

import UIKit
import Combine


class LoginSignupViewController: UIViewController {
    
    //MARK: Components
    lazy var verticalStackView:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.width(5)
        return stackView
    }()
    
    lazy var commonBackgroundView:CommonBackGroundView = {
       var view = CommonBackGroundView()
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    lazy var loginView:LoginView = {
       var view = LoginView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.delegate = self
        return view
    }()
    
    lazy var signUpView:SignUpView = {
       var view = SignUpView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    
    //MARK: properties
    private var _isToggled = false{
        didSet{
            loginView.isHidden = _isToggled
            signUpView.isHidden = !_isToggled
        }
    }
    
    private var viewModel:LoginSignupViewModel = .init()
    private var cancellables = Set<AnyCancellable>()

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
    }

//    @objc func signUpFireBase(){
//        if let email = emailField.text,let password = passwordField.text {
//            authManager?.createAccount(withEmail: email, password: password) { result, error in
//                print(result?.user.email)
//                print(error)
//            }
//        }
//    }
//    
//    @objc func signInFireBase(){
//        if let email = emailField.text,let password = passwordField.text {
//            authManager?.signInWithEmail(withEmail: email, password: password) { result, error in
//                print(result?.user.email)
//                print(error)
//            }
//        }
//    }
//    
//    @objc func logoutFireBase(){
//        authManager?.signOut { error in
//            print(error)
//            if error == nil {
//                print("Logout successful")
//            }
//        }
//    }
//    
//    @objc func fetchAllData(){
//        authManager?.fetchAllData()
//    }
//    
//    @objc func addAllData(){
//        authManager?.addDocuments()
//    }
//    
//    @objc func updateData(){
//        authManager?.updateData(documentID: "BYqbtHBH3vU27w7Yubeg", newData: ["name": "New Item", "value": 50])
//    }
//    
//    @objc func deleteData(){
//        authManager?.deleteData(documentID: "BYqbtHBH3vU27w7Yubeg")
//    }
}


 
//MARK: View Setup
extension LoginSignupViewController {
    
    func setupView(){
        addSubViews()
    }
    
    func addSubViews(){
        self.view.backgroundColor = .white
        self.view.addSubview(commonBackgroundView)
        commonBackgroundView.fillSuperview()

        self.view.addSubview(verticalStackView)
        verticalStackView.anchor(top: self.view.topAnchor,paddingTop: RM.shared.height(120))
        verticalStackView.centerX(inView: self.view)
        verticalStackView.addArrangedSubview(loginView)
        verticalStackView.addArrangedSubview(signUpView)
    }
    
}


//MARK: Setup Binding
extension LoginSignupViewController{
    private func setupBindings() {
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else {return}
                guard let message = message else {return}
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
                if isLogin {
                    let transactionManagerHomeViewController = TransactionManagerHomeViewController()
                    self.navigationController?.pushViewController(transactionManagerHomeViewController, animated: true)
                }else{
                    
                }
            }
            .store(in: &cancellables)
        
        authManager?.$isLoading
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



//MARK: login view delegate
extension LoginSignupViewController:LoginSignupViewProtocol{
    func didTapSiginInButton(_ sender: UIButton) {
        if sender.tag == 1 {
            viewModel.login(email: loginView.emailField.text, password: loginView.passwordField.text)}
        else {_isToggled = !_isToggled}
    }
    
    func didTapSignUpButotn(_ sender: UIButton) {
        if sender.tag == 2 {_isToggled = !_isToggled} else {viewModel.signUp(email: signUpView.emailField.text, password: signUpView.passwordField.text)}
    }
}
