//
//  AuthManager.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 27/6/24.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AuthManager:NSObject,ObservableObject {
    
    
    // MARK: - Properties
    @Published var isUserLoggedIn = false
    @Published var isLoading:Bool?
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupAuthStateChangeListener()
    }
    
}


// MARK: - Methods
extension AuthManager {
    
    // MARK: Auth State Change Listener
    /// Sets up the authentication state change listener to track user login status.
    private func setupAuthStateChangeListener() {
        isLoading = true
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isUserLoggedIn = user != nil
                print("User state : ",self.isUserLoggedIn)
                self.isLoading = false
            }
        }
    }
    
    // MARK: Sign Out
    /// Signs out the current user.
    /// - Parameter completion: Closure called upon completion with an optional error.
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }
}


// MARK: - Account Creation and Sign In
extension AuthManager {

    // MARK: Create Account

    /// Creates a new user account with the provided email and password.
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's desired password.
    ///   - completion: Closure called upon completion with an optional error.
    func createAccount(withEmail email: String, password: String, completion: @escaping (AuthDataResult?,Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(authResult, nil)
            }
        }
    }

    // MARK: Sign In with Email and Password

    /// Signs in the user with the provided email and password.
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's password.
    ///   - completion: Closure called upon completion with an optional error.
    func signInWithEmail(withEmail email: String, password: String, completion: @escaping (AuthDataResult?,Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(authResult, nil)
            }
        }
    }
    
}




//MARK: FIreStore data manager
extension AuthManager{
    
    func fetchAllData(){
        let db =  Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
          // Handle case where user is not signed in
          return
        }
        
        let userRef = db.collection("users").document(userID)
        let dataListRef = userRef.collection("dataList")
        
        dataListRef.getDocuments { documentSnap, error in
            
            if error != nil {
                print(error)
            }
            
            if let snap = documentSnap?.documents {
                for datas in snap{
                    print(datas.documentID)
                    print(datas.data())
                }
            }
        
        }
        
    }
    
    func addDocuments(){
        
        // Get reference to Firestore database
         let db = Firestore.firestore()
         
         // Get current user ID (assuming you have user authentication)
         guard let userID = Auth.auth().currentUser?.uid else { return }
         
         // Prepare your data item
         let newItem = MyDataItem(name: "New Item", value: 10)
         
         // Reference to user document and subcollection for data list
         let userRef = db.collection("users").document(userID)
         let dataListRef = userRef.collection("dataList")
         
         // Use addDocument to create a new document with a unique ID
         dataListRef.addDocument(data: newItem.dictionaryRepresentation()) { error in
           if let error = error {
             print("Error adding data: \(error)")
             // Handle error here (e.g., show an alert)
           } else {
             print("Data added successfully!")
             // Handle success (e.g., show confirmation message)
           }
         }
    }
    
    
    func  updateData(documentID: String, newData: [String: Any]) {
      // Get reference to Firestore database
      let db = Firestore.firestore()
      
      // Get reference to user document and subcollection for data list
      guard let userID = Auth.auth().currentUser?.uid else { return }
      let userRef = db.collection("users").document(userID)
      let dataListRef = userRef.collection("dataList")
      
      // Reference to the specific document to update
      let documentRef = dataListRef.document(documentID)
      
      // Update data with the prepared dictionary
      documentRef.updateData(newData) { error in
        if let error = error {
          print("Error updating data: \(error)")
          // Handle error here (e.g., show an alert)
        } else {
          print("Data updated successfully!")
          // Handle success (e.g., show confirmation message)
        }
      }
    }
    
    func deleteData(documentID: String) {
      // Get reference to Firestore database
      let db = Firestore.firestore()
      
      // Get reference to user document and subcollection for data list
      guard let userID = Auth.auth().currentUser?.uid else { return }
      let userRef = db.collection("users").document(userID)
      let dataListRef = userRef.collection("dataList")
      
      // Reference to the specific document to delete
      let documentRef = dataListRef.document(documentID)
      
      // Delete the document
      documentRef.delete() { error in
        if let error = error {
          print("Error deleting data: \(error)")
          // Handle error here (e.g., show an alert)
        } else {
          print("Data deleted successfully!")
          // Handle success (e.g., show confirmation message)
        }
      }
    }
    
}

struct MyDataItem {
  let name: String
  let value: Int
  
  // Optional: Add a function to convert the data item to a dictionary
  func dictionaryRepresentation() -> [String: Any] {
    return ["name": name, "value": value]
  }
}

