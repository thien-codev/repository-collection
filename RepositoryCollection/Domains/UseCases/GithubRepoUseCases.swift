//
//  GithubRepoUseCases.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

protocol GithubRepoUseCases {
    func fetchRepos() async -> [GithubRepoModel]
}

class GithubRepoUseCasesIml: GithubRepoUseCases {
    
    private let repo: GithubRepoRepository
    
    init(repo: GithubRepoRepository) {
        self.repo = repo
    }
    
    func fetchRepos() async -> [GithubRepoModel] {
        await repo.fetchRepos()
    }
}
