//
//  MainTabViewModel.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation

class MainTabViewModel: ObservableObject {
    
    enum Input {
        case selectHistoryUserInfo(GitHubUserModel)
        case updateSelectedTap(Tab)
    }
    
    @Published var selectedHistoryUserInfo: GitHubUserModel?
    @Published var selectedTab: Tab = .home
    @Published var recentTabs: [Tab] = [.home] {
        didSet {
            guard recentTabs != oldValue else { return }
            selectedTab = recentTabs.currentTab
        }
    }
    
    func trigger(_ input: Input) {
        switch input {
        case .selectHistoryUserInfo(let gitHubUserModel):
            onSelectHistoryUserInfo(gitHubUserModel)
        case .updateSelectedTap(let tab):
            var currentTaps = recentTabs
            currentTaps.insert(tab, at: 0)
            recentTabs = Array(currentTaps.prefix(2)) // only get current and previous tab
        }
    }
}

private extension MainTabViewModel {
    
    func onSelectHistoryUserInfo(_ userInfo: GitHubUserModel) {
        recentTabs.append(.home)
        selectedHistoryUserInfo = userInfo
    }
}
extension Array where Element == Tab {
    var currentTab: Tab {
        self.first ?? .home
    }
    
    var previousTab: Tab? {
        self[safe: 1]
    }
}


