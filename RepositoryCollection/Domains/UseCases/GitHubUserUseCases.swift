//
//  GitHubUserUseCases.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 02/07/2024.
//

import Foundation
import Combine

protocol GitHubUserUseCases {
    func fetchUserInfo(userId: String) -> AnyPublisher<GitHubUserModel, Error>
    func fetchUserEvents(userId: String) -> AnyPublisher<[UserEventModel], Error>
}

final class GitHubUserUseCasesIml {
    
    private let repo: UserInfoRepository
    
    init(repo: UserInfoRepository) {
        self.repo = repo
    }
}

extension GitHubUserUseCasesIml: GitHubUserUseCases {
    
    func fetchUserInfo(userId: String) -> AnyPublisher<GitHubUserModel, Error> {
        let subject = PassthroughSubject<GitHubUserModel, Error>()
        let trimUserId = userId.trim()
        if trimUserId.isEmpty {
            subject.send(completion: .finished)
        } else {
            Task {
                do {
                    let userInfo = try await repo.fetchUserInfo(userId: trimUserId)
                    subject.send(userInfo)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(error))
                }
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func fetchUserEvents(userId: String) -> AnyPublisher<[UserEventModel], Error> {
        let subject = PassthroughSubject<[UserEventModel], Error>()
        let trimUserId = userId.trim()
        if trimUserId.isEmpty {
            subject.send(completion: .finished)
        } else {
            Task {
                let userEvents = await repo.fetchUserEvents(trimUserId)
                subject.send(userEvents)
                subject.send(completion: .finished)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
