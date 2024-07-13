//
//  Int.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/07/2024.
//

import Foundation

extension Int {
    
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million * 10) / 10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand * 10) / 10)k"
        }
        else {
            return "\(self)"
        }
    }
    
    var isEmpty: Bool {
        return self == .zero
    }
    
    mutating func beZero() {
        self = .zero
    }
}
