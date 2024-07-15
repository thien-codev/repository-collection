//
//  GitHubRepository.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

protocol GitHubRepository {
    func fetchRepos(userId: String) async throws -> [GitHubRepoModel]
    func fetchSuggestionUsers(prefix: String) async -> [Owner]
}
