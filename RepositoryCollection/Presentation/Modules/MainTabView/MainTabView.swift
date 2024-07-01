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
    
    private let bottomBarHeight: CGFloat = 83
    @State var selectedTab: Tab = .home
    private var reposView: some View = ViewFactory<RepositoriesView>().build(RepositoriesViewVM.init)
        .tag(Tab.home)
    private var historyView: some View = ViewFactory<HistoryView>().build(HistoryViewModel.init)
        .tag(Tab.history)
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                reposView
                historyView
            }
            
            VStack{
                Spacer()
                tabBar
            }
        }
        .ignoresSafeArea()
    }
}

private extension MainTabView {
    
    var tabBar: some View {
        VStack {
            Divider()
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
        .frame(width: UIScreen.width, height: bottomBarHeight)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "87CEFA"))
                .opacity(0.4)
        }
        .animation(.bouncy, value: selectedTab)
    }
    
    var homeTabBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: Tab.home.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26)
                if selectedTab == .home {
                    Text(Tab.home.title)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 21)
                    .frame(width: 100, height: 42)
                    .foregroundColor(Color(hex: "90D5FF"))
                    .offset(x: selectedTab == .home ? 0 : 200)
                    .opacity(selectedTab == .home ? 1 : 0)
            }
            .onTapGesture {
                guard selectedTab != .home else { return }
                selectedTab = .home
            }
        }
        .foregroundStyle(Color(hex: "00008a"))
    }
    
    var historyTabBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: Tab.history.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                if selectedTab == .history {
                    Text(Tab.history.title)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 21)
                    .frame(width: 100, height: 42)
                    .foregroundColor(Color(hex: "90D5FF"))
                    .offset(x: selectedTab == .history ? 0 : -200)
                    .opacity(selectedTab == .history ? 1 : 0)
            }
            .onTapGesture {
                guard selectedTab != .history else { return }
                selectedTab = .history
            }
        }
        .foregroundStyle(Color(hex: "00008a"))
    }
    
}

