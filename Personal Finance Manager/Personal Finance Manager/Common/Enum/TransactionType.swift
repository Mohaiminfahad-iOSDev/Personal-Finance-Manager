//
//  TransactionType.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import Foundation


enum TransactionType:String{
    case income
    case expense
    
    var category:[String] {
        switch self {
        case .income:
            return ["Salary","Wages","Interest","Dividends","Rental Income","Freelance Income"]
        case .expense:
            return ["Bills & Utilities","Groceries","Transportation","Housing","Medical","Insurance","Gifts"]
        }
    }
    
}
