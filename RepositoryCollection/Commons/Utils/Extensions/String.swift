//
//  String.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation

extension String {
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func uppercasedFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }
}

extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
}

extension Optional where Wrapped == String {
    
    var isNotEmptyAndHasValue: Bool {
        guard let self else { return false }
        return hasValue && !self.isEmpty
    }
}
