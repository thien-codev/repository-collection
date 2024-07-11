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
        static var githubUser = "/users/%@"
        static var userEvent = "/users/%@/events"
    }
    
    static var baseUrl: String = {
        DIContainer.manager.appConfigurations.githubRepoBaseUrl
    }()
    
    static func githubRepos(of userId: String) -> Endpoint<[GitHubRepoModel]> {
        let path = String(format: Path.githubRepos, userId)
        return Endpoint<[GitHubRepoModel]>(baseUrl: baseUrl,
                                           path: path,
                                           method: .get)
    }
    
    static func githubUser(with userId: String) -> Endpoint<GitHubUserModel> {
        let path = String(format: Path.githubUser, userId)
        return Endpoint<GitHubUserModel>(baseUrl: baseUrl,
                                         path: path,
                                         method: .get)
    }
    
    static func userEvent(with userId: String) -> Endpoint<[UserEventModel]> {
        let path = String(format: Path.userEvent, userId)
        return Endpoint<[UserEventModel]>(baseUrl: baseUrl,
                                          path: path,
                                          method: .get)
    }
}
