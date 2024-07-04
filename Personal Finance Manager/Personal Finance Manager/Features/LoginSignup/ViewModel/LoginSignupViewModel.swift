//
//  LoginSignupViewModel.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import Foundation


final class LoginSignupViewModel:ObservableObject {
    
    // Output for error messages (bound to a Label in the View)
    @Published var errorMessage: String? = nil
    @Published var isLoading:Bool?
    
    
    init() {
        
    }
    
    
    // Function to validate email and password
    func validateCredentials(email: String?,password:String?) -> Bool {
        errorMessage = nil
        if let email = email , !email.isEmpty {
            if !isValidEmail(email: email) {
                errorMessage = "Invalid email format"
                return false
            }
        }else{
            errorMessage = "Email cannot be empty"
            return false
        }
        
        if let password = password , !password.isEmpty {
            
        }else{
            errorMessage = "Password cannot be empty"
            return false
        }
        return true
    }
    
    
    // Function to check email validity (using a regular expression)
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Function to handle login logic
    func login(email: String?,password:String?) {
       
        if validateCredentials(email: email, password: password) {
            isLoading = true
            authManager?.signInWithEmail(withEmail: email!, password: password!, completion: { result, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            })
        }
    }
    
    func signUp(email: String?,password:String?){
        
        if validateCredentials(email: email, password: password) {
            isLoading = true
            authManager?.createAccount(withEmail: email!, password: password!, completion: { result, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            })
        }
    }
}
