//
//  UserDefaultRepository.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 27/06/2024.
//

import Foundation

public extension DefaultsKey {
    
    /// GitHub user id
    static let recentSearchUsers = Key<[Owner]>("recentSearchUsers")
    
    /// appIcon
    static let appIcon = Key<AppIcon>("appIcon")
}
