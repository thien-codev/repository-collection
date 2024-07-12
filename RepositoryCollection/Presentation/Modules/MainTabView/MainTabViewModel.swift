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
        case showChartDetail([UserEventUIModel], CGRect)
        case closeChartDetail
        case showUserInfo(GitHubUserModel?, Bool)
        case closeUserInfo
    }
    
    @Published var onCloseChartDetail: Void?
    @Published var showChartDetail: Bool = false
    @Published var showBioUserInfo: Bool = false
    @Published var showSelectedHistoryUserInfo: Bool = false
    @Published var selectedTab: Tab = .home
    @Published var recentTabs: [Tab] = [.home] {
        didSet {
            guard recentTabs.currentTab != oldValue.currentTab else { return }
            selectedTab = recentTabs.currentTab
        }
    }
    
    var isShowFullAvatar: Bool = false
    var selectedUserInfo: GitHubUserModel?
    var chartDetailDislayData: [UserEventUIModel] = []
    var frameChartDetail: CGRect?
    
    func trigger(_ input: Input) {
        switch input {
        case .selectHistoryUserInfo(let gitHubUserModel):
            onSelectHistoryUserInfo(gitHubUserModel)
        case .updateSelectedTap(let tab):
            updateCurrentTab(to: tab)
        case .showUserInfo(let userInfo, let isFullAvatar):
            selectedUserInfo = userInfo
            isShowFullAvatar = isFullAvatar
            showBioUserInfo = true
        case .closeUserInfo:
            showBioUserInfo = false
        case .showChartDetail(let displayData, let frame):
            showChartDetail = true
            frameChartDetail = frame
            chartDetailDislayData = displayData
        case .closeChartDetail:
            onCloseChartDetail = ()
        }
    }
}

private extension MainTabViewModel {
    
    func onSelectHistoryUserInfo(_ userInfo: GitHubUserModel) {
        updateCurrentTab(to: .home)
        showSelectedHistoryUserInfo = true
        selectedUserInfo = userInfo
    }
    
    func updateCurrentTab(to tab: Tab) {
        var currentTaps = recentTabs
        currentTaps.insert(tab, at: 0)
        recentTabs = Array(currentTaps.prefix(2)) // only get current and previous tab
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


