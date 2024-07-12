//
//  Date.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 11/07/2024.
//

import Foundation

extension Date {
    
    var textInUTC: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func isSameDate(to another: Date?) -> Bool {
        guard let another else { return false }
        let calendar = Calendar.current
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let anotherComponents = calendar.dateComponents([.year, .month, .day], from: another)
        
        return selfComponents.year == anotherComponents.year &&
        selfComponents.month == anotherComponents.month &&
        selfComponents.day == anotherComponents.day
    }
}
