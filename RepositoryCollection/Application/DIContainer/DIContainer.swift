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
                       repoStorage: GithubRepoStorage) {
        manager.appConfigurations = appConfigurations
        manager.networkService = networkService
        manager.repoStorage = repoStorage
    }
    
    var appConfigurations: Configurations!
    var networkService: NetworkService!
    var repoStorage: GithubRepoStorage!
    
    lazy var dataTransferService: DataTransferService = {
        DefaultDataTransferService(service: networkService)
    }()
    
    lazy var githubRepo: GithubRepoRepository = {
        GithubRepoRepositoryIml(dataTransferService: dataTransferService,
                                githubRepoStorage: repoStorage)
    }()
    
    lazy var githubRepoUseCases: GithubRepoUseCases = {
        GithubRepoUseCasesIml(repo: githubRepo)
    }()
}
