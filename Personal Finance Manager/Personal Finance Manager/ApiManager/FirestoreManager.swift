//
//  TransactionApiManager.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    
    
    func getDocument(from collection: String, with documentID: String, completion: @escaping (Result<QuerySnapshot?, Error>) -> Void) {
        
        let userRef = db.collection(collection).document(documentID)
        let dataListRef = userRef.collection("dataList")
        
        dataListRef.getDocuments { querySnapShot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let query = querySnapShot else {
                completion(.success(nil))
                return
            }
            completion(.success(query))
        }
    }
    
    
    func deleteDocument(from collection: String,with userID:String, documentID:String ,completion: @escaping (Result<String?, Error>) -> Void){
        let userRef = db.collection(collection).document(userID)
        let dataListRef = userRef.collection("dataList")
        let documentRef = dataListRef.document(documentID)
        documentRef.delete { error in
            if let error = error {
                completion(.failure(error))
            }else{
                completion(.success("Data deleted successfully!"))
            }
        }
        
    }
    
    func addDocument(from collection: String,with userID:String, transaction:TransactionModel ,completion: @escaping (Result<String?, Error>) -> Void){
        let userRef = db.collection(collection).document(userID)
        let dataListRef = userRef.collection("dataList")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(transaction)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            dataListRef.addDocument(data: dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                }else{
                    completion(.success("Data added successfully!"))
                }
            }
        } catch {
            completion(.failure(error))
        }
        
    }
    
}

