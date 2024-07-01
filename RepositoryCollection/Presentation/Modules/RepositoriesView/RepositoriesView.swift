//
//  RepositoriesView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct RepositoriesView: GeneralView {
    
    @ObservedObject var viewModel: RepositoriesViewVM
    @State var isEnableSearch: Bool = false
    @FocusState var focusKeyboard: Bool
    private let paddingHorizontal: CGFloat = 20
    
    init(viewModel: RepositoriesViewVM) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            CustomNavigationView {
                ZStack(alignment: .top) {
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
                                    RepositoryCell(paddingHorizontal: paddingHorizontal, height: 180, repoModel: item)
                                }
                                .padding(.bottom, 6)
                            }
                            .padding([.leading, .trailing], paddingHorizontal)
                            .offset(y: 36)
                            
                            loadMoreView
                                .offset(y: 10)
                                .padding(.bottom, 20)
                                .padding(.top, 26)
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
                    .padding(.top, 50)
                    noResultFoundView
                    searchBar
                }
                .onTapGesture {
                    focusKeyboard = false
                }
                .customNavigationViewBarHidden(true)
            }
        }
    }
}

private extension RepositoriesView {
    
    var searchButton: some View {
        let shouldShow = (isEnableSearch || !viewModel.userID.isEmpty)
        return Circle()
            .stroke(lineWidth: 1)
            .foregroundColor(.black)
            .overlay {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                    .foregroundColor(.black)
            }
            .frame(width: 40)
            .onTapGesture {
                viewModel.trigger(.search)
                isEnableSearch = false
            }
            .background(content: {
                Circle().fill(.white)
                    .shadow(radius: 0, x: 8, y: 8)
            })
            .isHidden(!shouldShow)
    }
    
    var profileView: some View {
        let shouldShow = !isEnableSearch && viewModel.owner.hasValue
        let avatarURL = URL(string:  viewModel.owner?.avatarURL ?? "")
        return Circle()
            .stroke(lineWidth: 1)
            .foregroundColor(.black)
            .overlay {
                KFImage(avatarURL)
                    .placeholder {
                        Image(systemName: "person.crop.circle")
                    }
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.black)
                    .mask {
                        Circle()
                    }
            }
            .frame(width: 40)
            .onTapGesture {
                // show profile
            }
            .background(content: {
                Circle().fill(.white)
                    .shadow(radius: 0, x: 8, y: 8)
            })
            .isHidden(!shouldShow)
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
            .opacity(viewModel.canLoadMore ? 1 : 0)
            .onTapGesture {
                viewModel.trigger(.loadMore)
            }
    }
    
    var searchBar: some View {
        HStack(spacing: 14) {
            CustomTextField(placeholder: "Search GitHub",
                            text: $viewModel.userID,
                            isEnabled: $isEnableSearch,
                            backgroundColor: .white,
                            tint: .black,
                            focusKeyboard: $focusKeyboard)
            recentSearchButtonView
            searchButton
            profileView
        }
        .animation(.easeInOut, value: isEnableSearch)
        .animation(.easeInOut, value: viewModel.owner)
        .animation(.easeInOut, value: viewModel.userID)
        .animation(.easeInOut, value: viewModel.enableRecentSearch)
        .padding(20)
    }
    
    var recentSearchButtonView: some View {
        let shouldShow = viewModel.enableRecentSearch && !isEnableSearch
        return Circle()
            .stroke(lineWidth: 1)
            .foregroundColor(.black)
            .overlay {
                Image(systemName: "arrow.2.circlepath")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.black)
            }
            .frame(width: 40)
            .onTapGesture {
                viewModel.trigger(.recentSearchTrigger)
            }
            .background(content: {
                Circle().fill(.white)
                    .shadow(radius: 0, x: 8, y: 8)
            })
            .isHidden(!shouldShow)
    }
    
    var noResultFoundView: some View {
        let shouldShow: Bool = viewModel.hasNoRepo && !viewModel.userID.isEmpty && !isEnableSearch && !viewModel.isLoading
        return RoundedRectangle(cornerRadius: 12)
            .stroke(lineWidth: 1)
            .frame(height: 50)
            .overlay {
                Text("The user does not have any repository")
            }
            .background(content: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .shadow(radius: 0, x: 8, y: 8)
            })
            .padding([.leading, .trailing], 20)
            .offset(y: shouldShow ? 80 : -160)
            .animation(.spring(bounce: 0.15), value: shouldShow)
    }
}

#Preview {
    RepositoriesView(viewModel: .init(diContainer: .manager))
}
