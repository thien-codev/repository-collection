//
//  GithubRepoRepository.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

protocol GithubRepoRepository {
    func fetchRepos(userId: String) async throws -> [GithubRepoModel]
}
