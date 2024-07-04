//
//  Transactions+CoreDataProperties.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//
//

import Foundation
import CoreData


extension Transactions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transactions> {
        return NSFetchRequest<Transactions>(entityName: "Transactions")
    }

    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var transactionType: String?

}

extension Transactions : Identifiable {

}
