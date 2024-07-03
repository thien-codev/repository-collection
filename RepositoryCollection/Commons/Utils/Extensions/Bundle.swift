//
//  Bundle.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation

extension Bundle {
    struct Keys { }
    
    func plistValue<T>(for key: String) -> T? {
        infoDictionary?[key] as? T
    }
}

extension Bundle.Keys {
    static var githubRepoBaseUrl = "GitHubRepoBaseUrl"
}
