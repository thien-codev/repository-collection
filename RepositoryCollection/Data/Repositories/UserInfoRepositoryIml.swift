//
//  UserInfoRepositoryIml.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 02/07/2024.
//

import Foundation

final class UserInfoRepositoryIml {
    private let dataTransferService: DataTransferService
    private var currentTask: NetworkCancellable?
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension UserInfoRepositoryIml: UserInfoRepository {
    func fetchUserInfo(userId: String) async throws -> GitHubUserModel {
        return try await fetchUserInfoFromEndpoint(userId)
    }
}

private extension UserInfoRepositoryIml {
    func fetchUserInfoFromEndpoint(_ userId: String) async throws -> GitHubUserModel {
        try await withCheckedThrowingContinuation { continuation in
            let request = APIEndpoint.githubUser(with: userId)
            currentTask?.doCancel()
            currentTask = dataTransferService.request(endpoint: request, on: DispatchQueue.main) { result in
                switch result {
                case let .success(userInfo):
                    continuation.resume(returning: userInfo)
                case let .failure(error):
                    debugPrint("\(#function) ---> error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
