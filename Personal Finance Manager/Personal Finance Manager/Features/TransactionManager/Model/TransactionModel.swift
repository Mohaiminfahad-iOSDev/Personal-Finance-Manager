//
//  TransactionModel.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import Foundation
import FirebaseFirestore

struct TransactionModel: Codable,Hashable{
    var id:String?
    var transactionType: String?
    var title:String?
    var amount:String?
    var date: Timestamp?
    var category:String?
    var note:String?
}
