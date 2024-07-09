//
//  HistoryView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import SwiftUI
import Lottie

struct HistoryView: GeneralView {
    @ObservedObject var viewModel: HistoryViewModel
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    init(viewModel: HistoryViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            emptyView.isHidden(!viewModel.cacheUserInfos.isEmpty, remove: true)
            sectionView
        }
        .task {
            try? await Task.sleep(nanoseconds: 1 * 1000 * 1000 * 1000)
            viewModel.trigger(.fetchData)
        }
        .animation(.spring, value: viewModel.cacheUserInfos)
    }
}

private extension HistoryView {
    var sectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recently").font(.system(size: 16, weight: .semibold))
                .padding(.leading, 20)
                .isHidden(viewModel.cacheUserInfos.isEmpty, remove: true)
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.cacheUserInfos, id: \.id) { userInfo in
                    UserInfoCell(model: userInfo)
                        .onTapGesture {
                            mainTabViewModel.trigger(.selectHistoryUserInfo(userInfo))
                        }
                }
                .frame(width: UIScreen.width)
                .padding(.bottom, MainTabView.bottomBarHeight)
            }
        }
    }
    
    var emptyView: some View {
        let path = Bundle.main.path(forResource: "empty",
                                    ofType: "json") ?? ""
        let animationView = LottieView(animation: .filepath(path))
        return animationView.playing(loopMode: .loop)
    }
}
