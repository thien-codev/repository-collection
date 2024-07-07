//
//  HistoryUseCases.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import Combine

protocol HistoryUseCases {
    func fetchAllUserInfos() -> AnyPublisher<[GitHubUserModel], Error>
}

final class HistoryUseCasesIml {
    
    private let repo: UserInfoRepository
    
    init(repo: UserInfoRepository) {
        self.repo = repo
    }
}

extension HistoryUseCasesIml: HistoryUseCases {
    func fetchAllUserInfos() -> AnyPublisher<[GitHubUserModel], Error> {
        let subject = PassthroughSubject<[GitHubUserModel], Error>()
        
        Task {
            let cacheUserInfos = await repo.fetchAllUserInfos()
            subject.send(cacheUserInfos.filterDuplicates(includeElement: { $0.login == $1.login }))
            subject.send(completion: .finished)
        }
        
        return subject.eraseToAnyPublisher()
    }
}
