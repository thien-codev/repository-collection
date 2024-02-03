//
//  RepositoriesView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI

struct RepositoriesView: GeneralView {
    
    @ObservedObject var viewModel: RepositoriesViewVM
    @State var isEnableSearch: Bool = false
    
    init(viewModel: RepositoriesViewVM) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            CustomNavigationView {
                ZStack {
                    WaveBackgroundView()
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.displayItems, id: \.id) { item in
                                CustomNavigationLink {
                                    RepositoryDetailView(repoModel: item)
                                        .customNavigationViewTitle(item.fullName)
                                        .customNavigationViewBackgroundColor(.blue)
                                        .customNavigationViewTintColor(.white)
                                } label: {
                                    RepositoryCell(height: 180, repoModel: item)
                                }
                                .padding(.bottom, 10)
                            }
                            .padding([.leading, .trailing], 20)
                            .offset(y: 10)
                            
                            loadMoreView
                        }
                        .animation(.spring, value: viewModel.displayItems)
                        .alert(isPresented: $viewModel.alertMessage.isShowing) {
                            Alert(
                                title: Text("\(viewModel.alertMessage.title)"),
                                message: Text("\(viewModel.alertMessage.message)"),
                                dismissButton: .default(Text("Close"))
                            )
                        }
                    }
                }
                .customNavigationViewBackButtonHidden(true)
                .customNavigationViewBackgroundColor(.blue)
                .customNavigationViewTintColor(.white)
                .customNavigationViewRightItem(EquatableViewContainer(view: AnyView(searchBar)))
            }
        }
    }
    
    private var searchButton: some View {
        let shouldShow = (isEnableSearch || !viewModel.userID.isEmpty)
        return Circle()
            .foregroundColor(.blue)
            .overlay {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.black)
            }
            .frame(width: shouldShow ? 50 : 2)
            .opacity(shouldShow ? 1 : 0)
            .onTapGesture {
                viewModel.trigger(.search)
                isEnableSearch = false
            }
    }
    
    private var loadMoreView: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(lineWidth: 3)
            .frame(height: 50)
            .overlay {
                Text("Load more")
                    .font(.system(size: 26))
                    .fontWeight(.bold)
            }
            .background(content: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .shadow(radius: 0, x: 10, y: 10)
            })
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 40)
            .offset(y: 10)
            .opacity(viewModel.canLoadMore ? 1 : 0)
            .onTapGesture {
                viewModel.trigger(.loadMore)
            }
    }
    
    private var searchBar: some View {
        HStack {
            CustomTextField(placeholder: "UserID",
                            text: $viewModel.userID,
                            isEnabled: $isEnableSearch,
                            backgroundColor: .white,
                            tint: .black)
            searchButton
        }
        .animation(.easeInOut, value: isEnableSearch)
        .animation(.easeInOut, value: viewModel.userID)
        .padding([.leading, .trailing, .bottom])
    }
}

#Preview {
    RepositoriesView(viewModel: .init(diContainer: .manager))
}
