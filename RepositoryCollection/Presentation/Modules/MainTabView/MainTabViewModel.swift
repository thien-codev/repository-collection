//
//  MainTabViewModel.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation

class MainTabViewModel: ObservableObject {
    
    @Published var selectedHistoryUserInfo: GitHubUserModel?
    @Published var selectedTab: Tab = .home
    
    func onSelectHistoryUserInfo(_ userInfo: GitHubUserModel) {
        selectedTab = .home
        selectedHistoryUserInfo = userInfo
    }
}
