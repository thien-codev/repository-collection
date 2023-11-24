//
//  APIEndpoint.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation

struct APIEndpoint {
    
    struct Path {
        static var githubRepos = "/users/%@/repos"
    }
    
    static var baseUrl: String = {
        DIContainer.manager.appConfigurations.githubRepoBaseUrl
    }()
    
    static func githubRepos(of userId: String) -> Endpoint<[GithubRepoModel]> {
        let path = String(format: Path.githubRepos, userId)
        return Endpoint<[GithubRepoModel]>(baseUrl: baseUrl,
                                           path: path,
                                           method: .get)
    }
}
