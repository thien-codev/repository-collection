//
//  UserInfoRepositoryIml.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 02/07/2024.
//

import Foundation

final class UserInfoRepositoryIml {
    private let dataTransferService: DataTransferService
    private let userInfoStorage: UserInfoStorage
    private var currentTask: NetworkCancellable?
    
    init(dataTransferService: DataTransferService, userInfoStorage: UserInfoStorage) {
        self.dataTransferService = dataTransferService
        self.userInfoStorage = userInfoStorage
    }
}

extension UserInfoRepositoryIml: UserInfoRepository {
    
    func fetchUserInfo(userId: String) async throws -> GitHubUserModel {
        return try await fetchUserInfoFromEndpoint(userId)
    }
    
    func fetchUserEvents(_ userId: String) async -> [UserEventModel] {
        return await fetchUserEventsFromEndpoint(userId)
    }
    
    func fetchAllUserInfos() async -> [GitHubUserModel] {
        let cacheUserInfos = await userInfoStorage.getAllUserInfos()
        return cacheUserInfos
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
                    Task {
                        await self.userInfoStorage.save(userInfo: userInfo)
                    }
                    continuation.resume(returning: userInfo)
                case let .failure(error):
                    debugPrint("\(#function) ---> error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchUserEventsFromEndpoint(_ userId: String) async -> [UserEventModel] {
        await withCheckedContinuation { continuation in
            let request = APIEndpoint.userEvent(with: userId)
            _ = dataTransferService.request(endpoint: request, on: DispatchQueue.main) { result in
                switch result {
                case let .success(userEvents):
                    continuation.resume(returning: userEvents)
                case let .failure(error):
                    debugPrint("\(#function) ---> error: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
}
