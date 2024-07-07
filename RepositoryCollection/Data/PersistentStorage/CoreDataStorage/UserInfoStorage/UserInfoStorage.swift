//
//  UserInfoStorage.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation

protocol UserInfoStorage {
    func getAllUserInfos() async -> [GitHubUserModel]
    func save(userInfo: GitHubUserModel) async
}
