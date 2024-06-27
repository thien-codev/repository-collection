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
}

extension Optional where Wrapped == String {
    
    var isNotEmptyAndHasValue: Bool {
        guard let self else { return false }
        return hasValue && !self.isEmpty
    }
}
