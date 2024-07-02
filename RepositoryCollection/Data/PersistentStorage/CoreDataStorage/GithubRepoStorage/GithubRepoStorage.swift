//
//  GitHubRepoStorage.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation

protocol GitHubRepoStorage {
    func getRepos(of userID: String) async -> [GitHubRepoModel]
    func save(_ repos: [GitHubRepoModel], with userID: String) async
}
