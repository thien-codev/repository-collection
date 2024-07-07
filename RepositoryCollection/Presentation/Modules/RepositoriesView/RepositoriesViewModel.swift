//
//  RepositoriesViewModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import Combine

class RepositoriesViewModel: ObservableObject {
    
    enum Input {
        case search
        case loadMore
        case recentSearchTrigger
        case historySearch(GitHubUserModel)
    }
    
    private let backgrounds: [String] = ["im-1", "im-2", "im-3", "im-4", "im-5", "im-6"]
    private let limitItems = 5
    private let popularRepoThreshold = 6
    private let repoUseCases: GitHubRepoUseCases
    private let userUseCases: GitHubUserUseCases
    private var userDefaultRepo: UserDefaultRepository
    private let activityTracker = ActivityTracker(false)
    private let errorTracker = ErrorTracker()
    private var cancellable = Set<AnyCancellable>()
    private var returnedData: [GitHubRepoModel] = []
    private var storedItems: [GitHubRepoModel] = [] {
        didSet {
            guard storedItems != oldValue else { return }
            bindDisplayItems(with: storedItems)
        }
    }
    
    // Input
    @Published var userID: String = "" {
        didSet {
            hasNoRepo = false
            guard userID.isEmpty else { return }
            self.enableRecentSearch = userDefaultRepo.recentUserId.isNotEmptyAndHasValue
            self.clearData()
        }
    }
    
    // Output
    @Published var hasNoRepo: Bool = false
    @Published var enableRecentSearch: Bool = false
    @Published var canLoadMore = false
    @Published var displayItems: [GitHubRepoModel] = []
    @Published var isLoading: Bool = true
    @Published var alertMessage = AlertMessage()
    @Published var userInfo: GitHubUserModel? = nil
    
    var userInfoBackgroundImage: String {
        backgrounds.randomElement() ?? backgrounds[0]
    }
    
    var mostPopularRepos: [GitHubRepoModel] {
        return Array(returnedData.sorted(by: { $0.stargazersCount > $1.stargazersCount }).prefix(popularRepoThreshold))
    }
    
    var starred: Int {
        return returnedData.reduce(0) { partialResult, model in
            partialResult + model.stargazersCount
        }
    }
    
    var totalRepos: Int {
        return returnedData.count
    }
    
    convenience init(diContainer: DIContainer) {
        self.init(repoUseCases: diContainer.githubRepoUseCases,
                  userUseCases: diContainer.githubUserUseCases,
                  userDefaultRepo: diContainer.userDefaultRepository)
    }
    
    init(repoUseCases: GitHubRepoUseCases, userUseCases: GitHubUserUseCases, userDefaultRepo: UserDefaultRepository) {
        self.repoUseCases = repoUseCases
        self.userUseCases = userUseCases
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
            fetchUserInfo(userID: userID.trim())
        case .loadMore:
            storedItems.removeFirst(limitItems)
        case .recentSearchTrigger:
            fetchRecentSearch()
        case .historySearch(let userInfo):
            clearData()
            userID = userInfo.login
            fetchRepos(userID: userID.trim())
            fetchUserInfo(userID: userID.trim())
        }
    }
}

private extension RepositoriesViewModel {
    func fetchRepos(userID: String) {
        repoUseCases
            .fetchRepos(userId: userID)
            .trackActivity(activityTracker)
            .trackError(errorTracker)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.hasNoRepo = false
                case .finished: break
                }
            }, receiveValue: { [weak self] repos in
                self?.hasNoRepo = repos.isEmpty
                self?.storedItems = repos
                self?.returnedData = repos
            })
            .store(in: &cancellable)
    }
    
    func fetchUserInfo(userID: String) {
        userUseCases
            .fetchUserInfo(userId: userID)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] userInfo in
                self?.userInfo = userInfo
            })
            .store(in: &cancellable)
    }
    
    func bindDisplayItems(with storedItems: [GitHubRepoModel]) {
        displayItems.append(contentsOf: storedItems.prefix(limitItems))
        canLoadMore = storedItems.count > limitItems
        cacheRecentSearchId()
    }
    
    func clearData() {
        storedItems.removeAll()
        displayItems.removeAll()
        userInfo = nil
    }
    
    func fetchRecentSearch() {
        guard let recentUserId = userDefaultRepo.recentUserId, !recentUserId.isEmpty else { return }
        let trimId = recentUserId.trim()
        userID = trimId
        clearData()
        fetchRepos(userID: trimId)
        fetchUserInfo(userID: trimId)
    }
    
    func cacheRecentSearchId() {
        enableRecentSearch = userID.isEmpty
        guard !displayItems.isEmpty, !userID.isEmpty else { return }
        userDefaultRepo.recentUserId = userID
    }
}

extension GitHubRepoModel {
    static var mock: GitHubRepoModel = {
        .init(id: 1,
              name: "name",
              fullName: "fullName",
              owner: Owner(login: "", id: 0, nodeID: "", avatarURL: "", gravatarID: "", url: "", htmlURL: "", followersURL: "", followingURL: "", gistsURL: "", starredURL: "", subscriptionsURL: "", organizationsURL: "", reposURL: "", eventsURL: "", receivedEventsURL: "", type: "", siteAdmin: true),
              description: "description",
              createdAt: "createdAt",
              updatedAt: "updatedAt",
              pushedAt: "pushedAt",
              language: "language",
              visibility: "visibility")
    }()
}
