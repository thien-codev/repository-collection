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
                       networkService: NetworkService,
                       repoStorage: GitHubRepoStorage,
                       userDefaultRepository: UserDefaultRepository) {
        manager.appConfigurations = appConfigurations
        manager.networkService = networkService
        manager.repoStorage = repoStorage
        manager.userDefaultRepository = userDefaultRepository
    }
    
    var appConfigurations: Configurations!
    var networkService: NetworkService!
    var repoStorage: GitHubRepoStorage!
    var userDefaultRepository: UserDefaultRepository!
    
    lazy var dataTransferService: DataTransferService = {
        DefaultDataTransferService(service: networkService)
    }()
    
    lazy var githubRepo: GitHubRepository = {
        GitHubRepositoryIml(dataTransferService: dataTransferService,
                                githubRepoStorage: repoStorage)
    }()
    
    lazy var githubRepoUseCases: GitHubRepoUseCases = {
        GitHubRepoUseCasesIml(repo: githubRepo)
    }()
    
    lazy var githubUserUseCases: GitHubUserUseCases = {
        GitHubUserUseCasesIml(repo: githubRepo)
    }()
}
