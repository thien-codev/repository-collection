//
//  RepositoriesView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI

struct RepositoriesView: GeneralView {
    
    @StateObject var viewModel: RepositoriesViewVM
    @State var isEnableSearch: Bool = false
    
    init(viewModel: RepositoriesViewVM) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            NavigationView {
                ZStack {
                    WaveBackgroundView()
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(viewModel.displayItems.count) items")
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.leading, 32)
                            .foregroundColor(.gray)
                        HStack {
                            CustomTextField(placeholder: "UserID", 
                                            text: $viewModel.userID,
                                            isEnabled: $isEnableSearch)
                            searchButton
                        }
                        .animation(.easeInOut, value: isEnableSearch)
                        .animation(.easeInOut, value: viewModel.userID)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 10)
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.displayItems, id: \.id) { item in
                                NavigationLink {
                                    RepositoryDetailView(repoModel: item)
                                        .navigationBarBackButtonHidden(true)
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
            }
        }
    }
    
    private var searchButton: some View {
        let shouldShow = (isEnableSearch || !viewModel.userID.isEmpty)
        return Circle()
            .foregroundColor(.gray)
            .overlay {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.white)
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
}

#Preview {
    RepositoriesView(viewModel: .init(diContainer: .manager))
}
