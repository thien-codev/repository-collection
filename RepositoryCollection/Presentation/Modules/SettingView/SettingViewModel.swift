//
//  SettingViewModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 08/07/2024.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    enum Input {
        case changeAppIconSuccess(AppIcon)
    }
    
    @Published var appIcon: AppIcon
    
    private var userDefaultRepo: UserDefaultRepository
    
    convenience init(diContainer: DIContainer) {
        self.init(usesCases: diContainer.historyUseCases)
    }
    
    init(usesCases: HistoryUseCases) {
        userDefaultRepo = DIContainer.manager.userDefaultRepository
        appIcon = userDefaultRepo.appIcon
    }
    
    func trigger(_ input: Input) {
        switch input {
        case .changeAppIconSuccess(let appIcon):
            userDefaultRepo.appIcon = appIcon
            self.appIcon = appIcon
        }
    }
}
