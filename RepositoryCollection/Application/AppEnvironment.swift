//
//  AppEnvironment.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation
import SwiftUI

struct AppEnvironment {
    
    static func bootstrap() {
        
        let configurations = Configurations()
        let networkService = DefaultNetworkService(networkSessionManager: AFNetworkSessionManager.default)
        let coreDataStorage = CoreDataGithubRepoStorage(coreDataStack: CoreDataStorageStack.manager)
        let userDefaultRepo = UserDefaultRepositoryIml()
        
        DIContainer.inject(appConfigurations: configurations,
                           networkService: networkService,
                           repoStorage: coreDataStorage,
                           userDefaultRepository: userDefaultRepo)
    }
}

protocol GeneralView: View {
    associatedtype ViewModel
    
    var viewModel: ViewModel { get }
    init(viewModel: ViewModel)
}

struct ViewFactory<T: GeneralView> {
    private var diContainer: DIContainer = .manager
    
    func build(_ builder: (DIContainer) -> T.ViewModel) -> T {
        return T(viewModel: builder(diContainer))
    }
}
