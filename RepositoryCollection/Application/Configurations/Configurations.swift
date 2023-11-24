//
//  Configurations.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation

class Configurations {
    
    lazy var githubRepoBaseUrl: String = {
        guard let githubRepoBaseUrl: String = Bundle.main.plistValue(for: Bundle.Keys.githubRepoBaseUrl) else {
            fatalError("plist missing githubRepoBaseUrl")
        }
        return githubRepoBaseUrl
    }()
}
