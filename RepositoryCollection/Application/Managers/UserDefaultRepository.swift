//
//  UserDefaultRepository.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 27/06/2024.
//

import Foundation

protocol UserDefaultRepository {
    var defaultStorage: DefaultStorage { get }
    
    var recentSearchUsers: [Owner] { get set }
    var appIcon: AppIcon { get set }
}
