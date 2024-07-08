//
//  SettingViewModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 08/07/2024.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    convenience init(diContainer: DIContainer) {
        self.init(usesCases: diContainer.historyUseCases)
    }
    
    init(usesCases: HistoryUseCases) {
    }
}
