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
        case fillSuggestion(String)
    }
    
    private let limitRecentSearch: Int = 3
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
    
    private var recentSearchUsers: [Owner] {
        userDefaultRepo.recentSearchUsers
    }
    
    // Input
    @Published var userID: String = "" {
        didSet {
            if userID != oldValue {
                clearData()
            }
            guard userID.isEmpty else { return }
            self.enableRecentSearch = !userDefaultRepo.recentSearchUsers.isEmpty
        }
    }
    
    // Output
    @Published var isEnableSearchTextField: Bool = false
    @Published var alreadySearched: Bool = false
    @Published var reposNumbers: Int = 0
    @Published var enableRecentSearch: Bool = false
    @Published var canLoadMore = false
    @Published var displayItems: [GitHubRepoModel] = []
    @Published var isLoading: Bool = true
    @Published var alertMessage = AlertMessage()
    @Published var userInfo: GitHubUserModel? = nil
    @Published var userEvents: [UserEventUIModel] = []
    @Published var suggestionUsers: [Owner] = []
    
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
        self.enableRecentSearch = !userDefaultRepo.recentSearchUsers.isEmpty
        
        activityTracker
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellable)
        
        errorTracker
            .receive(on: DispatchQueue.main)
            .compactMap({ AlertMessage(error: $0) })
            .assign(to: \.alertMessage, on: self)
            .store(in: &cancellable)
        
        $userID
            .removeDuplicates()
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.fetchSuggestionUsers(prefix: value)
            }
            .store(in: &cancellable)
    }
    
    func trigger(_ input: Input) {
        switch input {
        case .search:
            isEnableSearchTextField = false
            suggestionUsers.removeAll()
            clearData()
            fetchRepos(userID: userID.trim())
            fetchUserInfo(userID: userID.trim())
        case .loadMore:
            suggestionUsers.removeAll()
            storedItems.removeFirst(limitItems)
        case .recentSearchTrigger:
            suggestionUsers.removeAll()
            fetchRecentSearch()
        case .historySearch(let userInfo):
            suggestionUsers.removeAll()
            isEnableSearchTextField = false
            clearData()
            userID = userInfo.login
            fetchRepos(userID: userID.trim())
            fetchUserInfo(userID: userID.trim())
        case .fillSuggestion(let userId):
            userID = userId.trim()
            suggestionUsers.removeAll()
            isEnableSearchTextField = false
            clearData()
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
                    self?.reposNumbers.beZero()
                case .finished: break
                }
            }, receiveValue: { [weak self] repos in
                self?.reposNumbers = repos.count
                self?.storedItems = repos
                self?.returnedData = repos
                self?.alreadySearched = true
            })
            .store(in: &cancellable)
    }
    
    func fetchSuggestionUsers(prefix: String) {
        repoUseCases
            .fetchSuggestionUsers(prefix: prefix)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] remoteSuggestionUsers in
                guard let self else { return }
                
                if prefix.isEmpty {
                    self.suggestionUsers = []
                } else {
                    var suggestionUsers: [Owner] = []
                    let recentSearchUsers = Array(self.recentSearchUsers.filter({ $0.login.lowercased().contains(prefix.lowercased()) }).prefix(self.limitRecentSearch))
                    if remoteSuggestionUsers.isEmpty {
                        suggestionUsers = recentSearchUsers
                    } else {
                        let filterRemoteSuggestionUsers = remoteSuggestionUsers.filter { owner in
                            return recentSearchUsers.contain { comparedOwner in
                                return owner.login == comparedOwner.login
                            }
                        }
                        suggestionUsers = recentSearchUsers + filterRemoteSuggestionUsers.filter({ $0.login.lowercased().contains(prefix.lowercased()) })
                    }
                    
                    self.suggestionUsers = suggestionUsers
                }
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
        
        userUseCases
            .fetchUserEvents(userId: userID)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] userEvents in
                let contributedEvents = userEvents.filter({ $0.type.isContributedEvent })
                self?.userEvents = contributedEvents.toUIModels
            })
            .store(in: &cancellable)
    }
    
    func bindDisplayItems(with storedItems: [GitHubRepoModel]) {
        displayItems.append(contentsOf: storedItems.prefix(limitItems))
        canLoadMore = storedItems.count > limitItems
        cacheRecentSearchUser()
    }
    
    func clearData() {
        storedItems.removeAll()
        displayItems.removeAll()
        userEvents.removeAll()
        userInfo = nil
        reposNumbers.beZero()
        alreadySearched = false
    }
    
    func fetchRecentSearch() {
        guard let recentUser = userDefaultRepo.recentSearchUsers.first, !recentUser.login.isEmpty else { return }
        let trimId = recentUser.login.trim()
        userID = trimId
        clearData()
        fetchRepos(userID: trimId)
        fetchUserInfo(userID: trimId)
    }
    
    func cacheRecentSearchUser() {
        enableRecentSearch = userID.isEmpty
        guard !displayItems.isEmpty, !userID.isEmpty, let owner = storedItems.first?.owner else { return }
        userDefaultRepo.recentSearchUsers.insert(owner, at: 0)
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

extension Array where Element == UserEventModel {
    var toUIModels: [UserEventUIModel] {
        var results: [UserEventUIModel] = []
        var initialList = self
        
        for item in self {
            if let itemCreatedDate = item.createdDate, initialList.contains(where: { $0.id == item.id }) {
                let eventsInSameDate = initialList.filter({ itemCreatedDate.isSameDate(to: $0.createdDate) == true })
                if !eventsInSameDate.isEmpty {
                    results.append(.init(types: eventsInSameDate.map({ $0.type }), createdDate: itemCreatedDate, message: eventsInSameDate.eventMessage))
                    initialList.removeAll(where: { item in
                        eventsInSameDate.contain { comparedItem in
                            return comparedItem.id == item.id
                        }
                    })
                }
            }
        }
        
        return results
    }
    
    var eventMessage: String {
        var message = ""
        var initialList = self
        
        while !initialList.isEmpty {
            let first = initialList.first
            let groupEvents = initialList.filter{( $0.type == first?.type )}
            
            if groupEvents.count == 1 {
                message += "- \(first?.message.uppercasedFirstLetter() ?? "")"
            } else {
                message += "- \(groupEvents.count) \(first?.type.title ?? "actions")".uppercasedFirstLetter()
            }
            initialList.removeAll(where: { item in
                groupEvents.contain { comparedItem in
                    return comparedItem.id == item.id
                }
            })
            if !initialList.isEmpty {
                message += "\n"
            }
        }
        
        return message
    }
}
