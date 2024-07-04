//
//  LocalCacheManager.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation
import CoreData

class LocalCacheManager {
    static let shared = LocalCacheManager()
    
    private let context = CoreDataService.shared.persistentContainer.viewContext
    
    private init() {}
    
    
    // Create (Insert)
    func createItem(transaction:TransactionModel) {
        let newItem = Transactions(context: context)
        newItem.id = transaction.id
        newItem.transactionType = transaction.transactionType
        newItem.title = transaction.title
        newItem.amount = transaction.amount
        newItem.date = transaction.date?.dateValue()
        newItem.category = transaction.category
        newItem.note = transaction.note
         
        // Save the context to persist changes
    
        do {
            try context.save()
        } catch {
            print("Error saving item: \(error.localizedDescription)")
            AlertPresenter().showAlertForError(errorString: error.localizedDescription)
        }
    }
    
    
    // Read (Fetch) with Fault
    func getAllCacheData() -> [Transactions] {
        let request = Transactions.fetchRequest()
        var items: [Transactions] = []
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching date: ",error)
            AlertPresenter().showAlertForError(errorString: error.localizedDescription)
        }
        
        
        return items
    }
    
    func removeAllCacheData() {
        let request = NSBatchDeleteRequest(fetchRequest: Transactions.fetchRequest())
        do {
            try context.execute(request)
        } catch {
            print("Error removing data",error)
            AlertPresenter().showAlertForError(errorString: error.localizedDescription)
        }
    }
    

    
    private func convertResponse<T: Decodable>(from value: NSData) -> T? {
        do {
            let model = try JSONDecoder().decode(T.self, from: Data(value))
            return model
        } catch {
            print("Error converting response: ",error)
            AlertPresenter().showAlertForError(errorString: error.localizedDescription)
        }
        return nil
    }
    
}
