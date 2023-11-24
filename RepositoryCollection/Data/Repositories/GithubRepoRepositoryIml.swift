//
//  GithubRepoRepositoryIml.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

class GithubRepoRepositoryIml: GithubRepoRepository {
    
    private let dataTransferService: DataTransferService
    private let githubRepoStorage: GithubRepoStorage
    private var currentTask: NetworkCancellable?
    
    init(dataTransferService: DataTransferService, githubRepoStorage: GithubRepoStorage) {
        self.dataTransferService = dataTransferService
        self.githubRepoStorage = githubRepoStorage
    }
    
    func fetchRepos(userId: String) async throws -> [GithubRepoModel] {
        let cacheRepos = await githubRepoStorage.getRepos(of: userId)
        if !cacheRepos.isEmpty {
            return cacheRepos
        } else {
            return try await fetchReposFromEndpoint(userId)
        }
    }
}

private extension GithubRepoRepositoryIml {
    func fetchReposFromEndpoint(_ userId: String) async throws -> [GithubRepoModel] {
        try await withCheckedThrowingContinuation { continuation in
            let request = APIEndpoint.githubRepos(of: userId)
            currentTask?.doCancel()
            currentTask = dataTransferService.request(endpoint: request, on: DispatchQueue.main) { result in
                switch result {
                case let .success(repos):
                    Task {
                        await self.githubRepoStorage.save(repos, with: userId)
                    }
                    continuation.resume(returning: repos)
                case let .failure(error):
                    debugPrint("\(#function) ---> error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
