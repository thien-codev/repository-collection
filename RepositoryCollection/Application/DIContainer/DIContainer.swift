//
//  DIContainer.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation
import SwiftUI

final class DIContainer {
    
    private init() { }
    
    static var manager = DIContainer()
    
    static func inject(appConfigurations: Configurations,
                       repoStorage: GitHubRepoStorage,
                       userDefaultRepository: UserDefaultRepository) {
        manager.appConfigurations = appConfigurations
        manager.repoStorage = repoStorage
        manager.userDefaultRepository = userDefaultRepository
    }
    
    var appConfigurations: Configurations!
    var repoStorage: GitHubRepoStorage!
    var userDefaultRepository: UserDefaultRepository!
    
    lazy var githubRepo: GitHubRepository = {
        let dataTransferService = DefaultDataTransferService(service: DefaultNetworkService(networkSessionManager: AFNetworkSessionManager()))
        return GitHubRepositoryIml(dataTransferService: dataTransferService,
                                githubRepoStorage: repoStorage)
    }()
    
    lazy var userInfoRepo: UserInfoRepository = {
        let dataTransferService = DefaultDataTransferService(service: DefaultNetworkService(networkSessionManager: AFNetworkSessionManager()))
        return UserInfoRepositoryIml(dataTransferService: dataTransferService, userInfoStorage: CoreDataUserInfoStorage(coreDataStack: .manager))
    }()
    
    lazy var githubRepoUseCases: GitHubRepoUseCases = {
        GitHubRepoUseCasesIml(repo: githubRepo)
    }()
    
    lazy var githubUserUseCases: GitHubUserUseCases = {
        GitHubUserUseCasesIml(repo: userInfoRepo)
    }()
    
    lazy var historyUseCases: HistoryUseCases = {
        HistoryUseCasesIml(repo: userInfoRepo)
    }()
}
