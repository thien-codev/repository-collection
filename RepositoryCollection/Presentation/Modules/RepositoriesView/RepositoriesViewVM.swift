//
//  RepositoriesViewVM.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import Combine

class RepositoriesViewVM: ObservableObject {
    
    enum Input {
        case search
        case loadMore
    }
    
    private let limitItems = 3
    private let useCases: GithubRepoUseCases
    private let activityTracker = ActivityTracker(false)
    private let errorTracker = ErrorTracker()
    private var cancellable = Set<AnyCancellable>()
    private var storedItems: [GithubRepoModel] = [] {
        didSet {
            bindDisplayItems(with: storedItems)
        }
    }
    
    // Input
    @Published var userID: String = ""
    
    // Output
    @Published var canLoadMore = false
    @Published var displayItems: [GithubRepoModel] = []
    @Published var isLoading: Bool = true
    @Published var alertMessage = AlertMessage()
    @Published var owner: Owner? = nil
    
    convenience init(diContainer: DIContainer) {
        self.init(useCases: diContainer.githubRepoUseCases)
    }
    
    init(useCases: GithubRepoUseCases) {
        self.useCases = useCases
        
        activityTracker
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellable)
        
        errorTracker
            .receive(on: DispatchQueue.main)
            .compactMap({ AlertMessage(error: $0) })
            .assign(to: \.alertMessage, on: self)
            .store(in: &cancellable)
    }
    
    func trigger(_ input: Input) {
        switch input {
        case .search:
            clearData()
            fetchRepos(userID: userID.trim())
        case .loadMore:
            storedItems.removeFirst(limitItems)
        }
    }
}

private extension RepositoriesViewVM {
    func fetchRepos(userID: String) {
        useCases
            .fetchRepos(userId: userID)
            .trackActivity(activityTracker)
            .trackError(errorTracker)
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: \.storedItems, on: self)
            .store(in: &cancellable)
    }
    
    func bindDisplayItems(with storedItems: [GithubRepoModel]) {
        displayItems.append(contentsOf: storedItems.prefix(limitItems))
        owner = storedItems.owner
        canLoadMore = storedItems.count > limitItems
    }
    
    func clearData() {
        storedItems.removeAll()
        displayItems.removeAll()
    }
}

extension GithubRepoModel {
    static var mock: GithubRepoModel = {
        .init(id: 1,
              name: "name",
              fullName: "fullName",
              owner: Owner(login: "login",
                           id: 1,
                           nodeID: "nodeID",
                           avatarURL: nil),
              description: "description",
              createdAt: "createdAt",
              updatedAt: "updatedAt",
              pushedAt: "pushedAt",
              language: "language",
              visibility: "visibility")
    }()
}
