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
        case recentSearchTrigger
    }
    
    private let limitItems = 3
    private let useCases: GithubRepoUseCases
    private var userDefaultRepo: UserDefaultRepository
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
    @Published var enableRecentSearch: Bool = false
    @Published var canLoadMore = false
    @Published var displayItems: [GithubRepoModel] = []
    @Published var isLoading: Bool = true
    @Published var alertMessage = AlertMessage()
    @Published var owner: Owner? = nil
    
    convenience init(diContainer: DIContainer) {
        self.init(useCases: diContainer.githubRepoUseCases,
                  userDefaultRepo: diContainer.userDefaultRepository)
    }
    
    init(useCases: GithubRepoUseCases, userDefaultRepo: UserDefaultRepository) {
        self.useCases = useCases
        self.userDefaultRepo = userDefaultRepo
        self.enableRecentSearch = userDefaultRepo.recentUserId.isNotEmptyAndHasValue
        
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
        case .recentSearchTrigger:
            fetchRecentSearch()
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
        cacheRecentSearchId()
    }
    
    func clearData() {
        storedItems.removeAll()
        displayItems.removeAll()
    }
    
    func fetchRecentSearch() {
        guard let recentUserId = userDefaultRepo.recentUserId, !recentUserId.isEmpty else { return }
        userID = recentUserId
        clearData()
        fetchRepos(userID: recentUserId.trim())
    }
    
    func cacheRecentSearchId() {
        enableRecentSearch = userID.isEmpty
        guard !displayItems.isEmpty, !userID.isEmpty else { return }
        userDefaultRepo.recentUserId = userID
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
