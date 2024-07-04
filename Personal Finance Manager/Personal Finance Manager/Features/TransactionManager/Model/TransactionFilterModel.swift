//
//  TransactionFilderModel.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation
import FirebaseFirestore

struct TransactionFilterModel {
    var date: Timestamp?
    var category:String?
    var range:amountRange?
}

struct amountRange{
    var from:Double?
    var to:Double?
}
