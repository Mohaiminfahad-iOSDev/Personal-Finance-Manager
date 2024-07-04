//
//  TransactionsEntryViewProtocol.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 2/7/24.
//

import Foundation

protocol TransactionsEntryViewProtocol:AnyObject {
    func didAddTransactionData(transaction:TransactionModel)
}
