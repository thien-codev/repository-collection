//
//  MainTabView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import SwiftUI
import Kingfisher

enum Tab: CaseIterable {
    case home
    case history
    case setting
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .history:
            return "Hitory"
        case .setting:
            return "Setting"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.circle"
        case .history:
            return "clock"
        case .setting:
            return "gearshape"
        }
    }
    
    var isHome: Bool {
        return self == .home
    }
}


struct MainTabView: View {
    
    private let tabbarButtonWidth: CGFloat = 106
    static let bottomBarHeight: CGFloat = 96
    @State var selectedHistoryUserInfo: GitHubUserModel?
    @StateObject var viewModel = MainTabViewModel()
    
    var reposView: RepositoriesView?
    var historyView: HistoryView?
    var settingView: SettingView?
    
    init() {
        reposView = ViewFactory<RepositoriesView>().build(RepositoriesViewModel.init)
        historyView = ViewFactory<HistoryView>().build(HistoryViewModel.init)
        settingView = ViewFactory<SettingView>().build(SettingViewModel.init)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                Group {
                    reposView.tag(Tab.home)
                    historyView.tag(Tab.history)
                    settingView.tag(Tab.setting)
                }.toolbar(.hidden, for: .tabBar)
            }
            
            VStack{
                Spacer()
                tabBar
            }
        }
        .ignoresSafeArea()
        .eraseToAnyView()
        .environmentObject(viewModel)
        .onReceive(viewModel.$showBioUserInfo, perform: { showUserInfo in
            guard showUserInfo else { return }
            let bioView = UIHostingController(rootView: BioInfoView(isPresented: $viewModel.showBioUserInfo, avatarUrlString: viewModel.selectedUserInfo?.avatarURL, info: viewModel.selectedUserInfo?.bio, isFullAvatar: viewModel.isShowFullAvatar))
            bioView.modalPresentationStyle = .overFullScreen
            bioView.modalTransitionStyle = .crossDissolve
            bioView.view.backgroundColor = .clear
            UIApplication.topViewController()?.present(bioView, animated: true)
        })
        .animation(.easeInOut, value: viewModel.showBioUserInfo)
    }
}

private extension MainTabView {
    
    var tabBar: some View {
        VStack {
            Spacer()
            HStack(content: {
                Group {
                    ForEach(Tab.allCases, id: \.title) { item in
                        switch item {
                        case .home:
                            homeTabBar
                        case .history:
                            historyTabBar
                        case .setting:
                            settingTabBar
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
            })
            Spacer()
        }
        .frame(width: UIScreen.width, height: MainTabView.bottomBarHeight)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .stroke(lineWidth: 1)
                .fill(Color(hex: "00008a"))
                .background {
                    RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "33ABF9"))
                }
        }
        .animation(.bouncy, value: viewModel.selectedTab)
    }
    
    var homeTabBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: Tab.home.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26)
                if viewModel.selectedTab == .home {
                    Text(Tab.home.title)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .scaleEffect(viewModel.selectedTab == .home ? 1.1 : 0.9, anchor: .center)
            .background {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(lineWidth: 1)
                    .frame(width: tabbarButtonWidth, height: 44)
                    .foregroundColor(Color(hex: "00008a"))
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .frame(width: tabbarButtonWidth, height: 44)
                            .foregroundColor(Color(hex: "90D5FF"))
                            .shadow(radius: 0, x: 6, y: 6)
                    }
                    .offset(x: viewModel.selectedTab == .home ? 0 : tabbarButtonWidth)
                    .opacity(viewModel.selectedTab == .home ? 1 : 0)
            }
            .onTapGesture {
                guard viewModel.selectedTab != .home else { return }
                viewModel.trigger(.updateSelectedTap(.home))
            }
        }
        .foregroundStyle(Color(hex: "00008a"))
    }
    
    var historyTabBar: some View {
        HStack {
            HStack(spacing: 8) {
                if viewModel.selectedTab == .history {
                    Text(Tab.history.title)
                        .font(.system(size: 14, weight: .medium))
                }
                Image(systemName: Tab.history.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .scaleEffect(viewModel.selectedTab == .history ? 1.1 : 0.9, anchor: .center)
            .background {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(lineWidth: 1)
                    .frame(width: 106, height: 44)
                    .foregroundColor(Color(hex: "00008a"))
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .frame(width: 106, height: 44)
                            .foregroundColor(Color(hex: "90D5FF"))
                            .shadow(radius: 0, x: 6, y: 6)
                    }
                    .offset(x: viewModel.selectedTab == .history ? 0 : viewModel.selectedTab == .home ? -tabbarButtonWidth : tabbarButtonWidth)
                    .opacity(viewModel.selectedTab == .history ? 1 : 0)
            }
            .onTapGesture {
                guard viewModel.selectedTab != .history else { return }
                viewModel.trigger(.updateSelectedTap(.history))
            }
        }
        .foregroundStyle(Color(hex: "00008a"))
    }
    
    var settingTabBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: Tab.setting.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                
                if viewModel.selectedTab == .setting {
                    Text(Tab.setting.title)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .scaleEffect(viewModel.selectedTab == .setting ? 1.1 : 0.9, anchor: .center)
            .background {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(lineWidth: 1)
                    .frame(width: 106, height: 44)
                    .foregroundColor(Color(hex: "00008a"))
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .frame(width: 106, height: 44)
                            .foregroundColor(Color(hex: "90D5FF"))
                            .shadow(radius: 0, x: 6, y: 6)
                    }
                    .offset(x: viewModel.selectedTab == .setting ? 0 : -tabbarButtonWidth)
                    .opacity(viewModel.selectedTab == .setting ? 1 : 0)
            }
            .onTapGesture {
                guard viewModel.selectedTab != .setting else { return }
                viewModel.trigger(.updateSelectedTap(.setting))
            }
        }
        .foregroundStyle(Color(hex: "00008a"))
    }
    
}

