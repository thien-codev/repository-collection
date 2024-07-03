//
//  GitHubRepoUseCases.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import Combine

protocol GitHubRepoUseCases {
    func fetchRepos(userId: String) -> AnyPublisher<[GitHubRepoModel], Error>
}

enum UseCasesError: Error, LocalizedError {
    case emptyParam
    case general(Error)
    
    public var errorDescription: String? {
        switch self {
        case .emptyParam:
            NSLocalizedString("You need to enter userID", comment: "My error")
        case .general(let error):
            error.localizedDescription
        }
    }
}

final class GitHubRepoUseCasesIml {
    
    private let repo: GitHubRepository
    
    init(repo: GitHubRepository) {
        self.repo = repo
    }
}

extension GitHubRepoUseCasesIml: GitHubRepoUseCases {
    
    func fetchRepos(userId: String) -> AnyPublisher<[GitHubRepoModel], Error> {
        let subject = PassthroughSubject<[GitHubRepoModel], Error>()
        if userId.isEmpty {
            subject.send(completion: .failure(UseCasesError.emptyParam))
        } else {
            Task {
                do {
                    let repos = try await repo.fetchRepos(userId: userId)
                    subject.send(repos)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(error))
                }
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
