//
//  HistoryViewModel.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    
    enum Input {
        case fetchData
    }
    
    private var cancellable = Set<AnyCancellable>()
    private let activityTracker = ActivityTracker(false)
    
    @Published var cacheUserInfos: [GitHubUserModel] = []
    @Published var isLoading: Bool = true
    
    convenience init(diContainer: DIContainer) {
        self.init(usesCases: diContainer.historyUseCases)
    }
    
    init(usesCases: HistoryUseCases) {
        self.usesCases = usesCases
        
        activityTracker
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellable)
    }
    
    private let usesCases: HistoryUseCases
    
    func trigger(_ input: Input) {
        switch input {
        case .fetchData:
            fetchCacheUserInfos()
        }
    }
}

private extension HistoryViewModel {
    func fetchCacheUserInfos() {
        usesCases
            .fetchAllUserInfos()
            .trackActivity(activityTracker)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] cacheUserInfos in
                self?.cacheUserInfos = cacheUserInfos
            })
            .store(in: &cancellable)
    }
}
