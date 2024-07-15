//
//  UserDefaultRepositoryIml.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 27/06/2024.
//

import Foundation

class UserDefaultRepositoryIml: UserDefaultRepository {
    
    var defaultStorage: DefaultStorage = .shared
    
    var recentSearchUsers: [Owner] {
        get {
            defaultStorage.get(forKey: .recentSearchUsers) ?? []
        }
        set {
            let newItems = newValue.filterDuplicates(includeElement: { $0.login == $1.login })
            defaultStorage.set(newItems, forKey: .recentSearchUsers)
        }
    }
    
    var appIcon: AppIcon {
        get { defaultStorage.get(forKey: .appIcon) ?? .initial }
        set { defaultStorage.set(newValue, forKey: .appIcon)}
    }
}
