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
        case loadMore
    }
    
    private let limitItems: Int = 5
    private let activityTracker = ActivityTracker(false)
    private var cancellable = Set<AnyCancellable>()
    private var returnedData: [GitHubUserModel] = [] {
        didSet {
            bindDisplayData(items: returnedData)
        }
    }
    
    @Published var displayedData: [GitHubUserModel] = []
    @Published var isLoading: Bool = true
    @Published var canLoadMore = false
    
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
            clearData()
            fetchCacheUserInfos()
        case .loadMore:
            returnedData.removeFirst(limitItems)
        }
    }
}

private extension HistoryViewModel {
    
    func clearData() {
        displayedData.removeAll()
        canLoadMore = false
    }
    
    func bindDisplayData(items: [GitHubUserModel]) {
        displayedData.append(contentsOf: items.prefix(limitItems))
        canLoadMore = items.count > limitItems
    }
    
    func fetchCacheUserInfos() {
        usesCases
            .fetchAllUserInfos()
            .trackActivity(activityTracker)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] cacheUserInfos in
                guard let self else { return }
                self.returnedData = cacheUserInfos
            })
            .store(in: &cancellable)
    }
}
