//
//  TransactionListSection.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation

struct TransactionListSection<I: Hashable>: Hashable {
    let sectionType: TransactionListSectionType
    var items: [I]
}
