//
//  MainTabView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import SwiftUI

enum Tab {
    case home
    case history
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .history:
            return "Hitory"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.circle"
        case .history:
            return "clock"
        }
    }
    
    var isHome: Bool {
        return self == .home
    }
}


struct MainTabView: View {
    
    static let bottomBarHeight: CGFloat = 96
    @State var selectedHistoryUserInfo: GitHubUserModel?
    @StateObject var viewModel = MainTabViewModel()
    
    var reposView: RepositoriesView?
    var historyView: HistoryView?
    
    init() {
        reposView = ViewFactory<RepositoriesView>().build(RepositoriesViewModel.init)
        historyView = ViewFactory<HistoryView>().build(HistoryViewModel.init)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                Group {
                    reposView.tag(Tab.home)
                    historyView.tag(Tab.history)
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
    }
}

private extension MainTabView {
    
    var tabBar: some View {
        VStack {
            Spacer()
            HStack(content: {
                Group {
                    ForEach([Tab.home, Tab.history], id: \.title) { item in
                        switch item {
                        case .home:
                            homeTabBar
                        case .history:
                            historyTabBar
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
                    .frame(width: 106, height: 44)
                    .foregroundColor(Color(hex: "00008a"))
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .frame(width: 106, height: 44)
                            .foregroundColor(Color(hex: "90D5FF"))
                            .shadow(radius: 0, x: 6, y: 6)
                    }
                    .offset(x: viewModel.selectedTab == .home ? 0 : 200)
                    .opacity(viewModel.selectedTab == .home ? 1 : 0)
            }
            .onTapGesture {
                guard viewModel.selectedTab != .home else { return }
                viewModel.selectedTab = .home
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
                    .offset(x: viewModel.selectedTab == .history ? 0 : -200)
                    .opacity(viewModel.selectedTab == .history ? 1 : 0)
            }
            .onTapGesture {
                guard viewModel.selectedTab != .history else { return }
                viewModel.selectedTab = .history
            }
        }
        .foregroundStyle(Color(hex: "00008a"))
    }
    
}

