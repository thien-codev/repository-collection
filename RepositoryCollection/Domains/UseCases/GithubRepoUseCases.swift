//
//  GithubRepoUseCases.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import Combine

protocol GithubRepoUseCases {
    func fetchRepos(userId: String) -> AnyPublisher<[GithubRepoModel], Error>
}

final class GithubRepoUseCasesIml: GithubRepoUseCases {
    
    private let repo: GithubRepoRepository
    
    init(repo: GithubRepoRepository) {
        self.repo = repo
    }
    
    func fetchRepos(userId: String) -> AnyPublisher<[GithubRepoModel], Error> {
        let subject = PassthroughSubject<[GithubRepoModel], Error>()
        Task {
            do {
                let repos = try await repo.fetchRepos(userId: userId)
                subject.send(repos)
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
