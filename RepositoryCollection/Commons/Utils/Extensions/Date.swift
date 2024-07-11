//
//  Date.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 11/07/2024.
//

import Foundation

extension Date {
    var text: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return components.description
    }
    
    func isEqual(to another: Date) -> Bool {
        let calendar = Calendar.current
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let anotherComponents = calendar.dateComponents([.year, .month, .day], from: another)
        
        return selfComponents.year == anotherComponents.year &&
        selfComponents.month == anotherComponents.month &&
        selfComponents.day == anotherComponents.day
    }
}
