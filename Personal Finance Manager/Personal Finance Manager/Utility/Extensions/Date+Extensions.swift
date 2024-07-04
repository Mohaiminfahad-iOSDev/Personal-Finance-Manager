//
//  Date+Extensions.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension Date {
    func dayMonthYearString() -> (String, String, Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy" // Day (2 digits), Full month name, Year
        let formattedString = formatter.string(from: self)
        let components = formattedString.components(separatedBy: " ")
        guard components.count == 3 else { return ("", "", 0) }
        let day = components[0]
        let month = components[1]
        let year = Int(components[2])!
        return (day, month, year)
    }
}

extension Date {
    func formattedMinusOne(format: String = "yyyy-MM-dd") -> String {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day! -= 1 // Add 1 day to the day component
        let tomorrow = calendar.date(from: components)!
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: tomorrow)
    }
    
    func formatted(format: String = "yyyy-MM-dd") -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        //        components.day! -= 1 // Add 1 day to the day component
        let tomorrow = calendar.date(from: components)!
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: tomorrow)
    }
}

extension Date {
    func dateFromCurrentTimeZone() -> Date{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        let date = Date(timeInterval: seconds, since: self)
        return date
    }
    
    func dateComponent() -> DateComponents{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day,.hour,.minute,.second], from: self)
        return components
    }
}
