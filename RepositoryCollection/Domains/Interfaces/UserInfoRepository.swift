//
//  UserInfoRepository.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 02/07/2024.
//

import Foundation

protocol UserInfoRepository {
    func fetchUserInfo(userId: String) async throws -> GitHubUserModel
    func fetchAllUserInfos() async -> [GitHubUserModel]
}
