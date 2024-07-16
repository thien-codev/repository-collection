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
            emptyView.isHidden(!viewModel.displayedData.isEmpty, remove: true)
            sectionView.ignoresSafeArea(edges: .bottom)
        }
        .task {
            try? await Task.sleep(nanoseconds: 1 * 1000 * 1000 * 1000)
            viewModel.trigger(.fetchData)
        }
        .animation(.spring, value: viewModel.displayedData)
    }
}

private extension HistoryView {
    var sectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recently").font(.system(size: 16, weight: .semibold))
                .padding(.leading, 20)
                .isHidden(viewModel.displayedData.isEmpty, remove: true)
            ScrollView(showsIndicators: false) {
                Group {
                    ForEach(viewModel.displayedData, id: \.id) { userInfo in
                        UserInfoCell(model: userInfo)
                            .onTapGesture {
                                mainTabViewModel.trigger(.selectHistoryUserInfo(userInfo))
                            }
                    }
                    .frame(width: UIScreen.width)
                    loadMoreView.padding(.top, 8)
                }
                .padding(.bottom, MainTabView.bottomBarHeight + 20)
            }
        }
    }
    
    var loadMoreView: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 1)
            .frame(height: 40)
            .overlay {
                Text("Load more")
                    .font(.system(size: 14, weight: .semibold))
            }
            .background(content: {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 40)
                    .foregroundColor(Color(hex: "90D5FF").opacity(0.8))
            })
            .padding([.leading, .trailing], 20)
            .onTapGesture {
                viewModel.trigger(.loadMore)
            }
            .isHidden(!viewModel.canLoadMore, remove: true)
    }
    
    var emptyView: some View {
        let path = Bundle.main.path(forResource: "empty",
                                    ofType: "json") ?? ""
        let animationView = LottieView(animation: .filepath(path))
        return animationView.playing(loopMode: .loop).animationSpeed(2)
    }
}
