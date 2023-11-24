//
//  GithubRepoStorage.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation

protocol GithubRepoStorage {
    func getRepos(of userID: String) async -> [GithubRepoModel]
    func save(_ repos: [GithubRepoModel], with userID: String) async
}
