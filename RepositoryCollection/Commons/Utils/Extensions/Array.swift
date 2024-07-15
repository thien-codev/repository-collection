//
//  Array.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation

extension Array where Element: Equatable {
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results: [Element] = []

        forEach { element in
            if !results.contains(where: { includeElement(element, $0) }) {
                results.append(element)
            }
        }
        return results
    }
    
    subscript (safe index: Index) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    func contain(comparasion: @escaping (Element) -> Bool) -> Bool {
        self.contains(where: { comparasion($0) })
    }
}
