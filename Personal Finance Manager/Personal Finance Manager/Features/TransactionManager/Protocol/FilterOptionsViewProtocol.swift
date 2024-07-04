//
//  FilterOptionsViewProtocol.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation

protocol FilterOptionsViewProtocol:AnyObject{
    func didTapApplyFilter(filter:TransactionFilterModel)
    func didTapClearAllFilter()
}
