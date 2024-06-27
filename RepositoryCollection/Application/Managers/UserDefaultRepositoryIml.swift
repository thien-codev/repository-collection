//
//  UserDefaultRepositoryIml.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 27/06/2024.
//

import Foundation

class UserDefaultRepositoryIml: UserDefaultRepository {
    
    var defaultStorage: DefaultStorage = .shared
    
    var recentUserId: String? {
        get { defaultStorage.get(forKey: .recentUserId) }
        set { defaultStorage.set(newValue, forKey: .recentUserId)}
    }
}
