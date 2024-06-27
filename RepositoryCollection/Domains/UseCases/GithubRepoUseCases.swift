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

final class GithubRepoUseCasesIml {
    
    private let repo: GithubRepoRepository
    
    init(repo: GithubRepoRepository) {
        self.repo = repo
    }
}

extension GithubRepoUseCasesIml: GithubRepoUseCases {
    
    func fetchRepos(userId: String) -> AnyPublisher<[GithubRepoModel], Error> {
        let subject = PassthroughSubject<[GithubRepoModel], Error>()
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
