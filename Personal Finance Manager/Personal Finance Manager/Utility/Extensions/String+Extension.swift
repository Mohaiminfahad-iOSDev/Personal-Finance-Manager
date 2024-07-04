//
//  String+Extension.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 4/7/24.
//

import Foundation
import UIKit

extension String {
    
    func toDate(format:String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
    
}
