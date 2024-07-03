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
    @State var userInfoSheetPresented: Bool = false
    @State var sharedSheetPresented: Bool = false
    @State var userInfoPresentationDetent: PresentationDetent = .medium
    @FocusState var focusKeyboard: Bool
    private let paddingHorizontal: CGFloat = 20
    
    init(viewModel: RepositoriesViewVM) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            CustomNavigationView {
                ZStack(alignment: .top) {
                    WaveBackgroundView().blur(radius: viewModel.displayItems.isEmpty ? 0 : 4)
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollViewReader { value in
                            ScrollView(showsIndicators: false) {
                                ForEach(viewModel.displayItems, id: \.id) { item in
                                    let repoDetailView = RepositoryDetailView(repoModel: item)
                                        .customNavigationViewTitle(item.fullName)
                                        .customNavigationViewBackgroundColor(.blue)
                                        .customNavigationViewTintColor(.white)
                                    CustomNavigationLink {
                                        repoDetailView
                                    } label: {
                                        RepositoryCell(paddingHorizontal: paddingHorizontal, repoModel: item, presentationMode: .large)
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
                            .alert(isPresented: $viewModel.alertMessage.isShowing) {
                                Alert(
                                    title: Text("\(viewModel.alertMessage.title)"),
                                    message: Text("\(viewModel.alertMessage.message)"),
                                    dismissButton: .default(Text("Close"))
                                )
                            }
                        }
                    }
                    .padding([.top, .bottom], 50)
                    noResultFoundView
                    searchBar
                }
                .animation(.spring, value: viewModel.displayItems)
                .onTapGesture {
                    focusKeyboard = false
                }
                .customNavigationViewBarHidden(true)
                .sheet(isPresented: $userInfoSheetPresented,
                       onDismiss: { userInfoPresentationDetent = .medium },
                       content: { userInfoModal })
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
        let shouldShow = !isEnableSearch && viewModel.userInfo.hasValue
        let avatarURL = URL(string: viewModel.userInfo?.avatarURL ?? "")
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
                userInfoSheetPresented = true
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
        .animation(.easeInOut, value: viewModel.userInfo)
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
    
    var userInfoModal: some View {
        @Environment(\.dismiss) var dismiss
        
        return VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 10)
                .frame(width: UIScreen.width, height: 300)
                .foregroundColor(.white)
                .background {
                    LinearGradient(colors: userInfoPresentationDetent == .medium ? [Color(hex: "33ABF9"), .white, .white] : [Color(hex: "33ABF9"), .white], startPoint: .top, endPoint: .bottom)
                }
                .overlay {
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                                .onTapGesture {
                                    sharedSheetPresented = true
                                }
                                .foregroundColor(Color(hex: "000072"))
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 4)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white.opacity(0.8))
                                        .blur(radius: 3)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color(hex: "33ABFF"))
                                                .shadow(color: Color(hex: "33ABFF"), radius: 3, x: 3, y: 3)
                                        }
                                }
                                .padding(.trailing, 30)
                                .padding(.top, 26)
                        }
                        Spacer()
                        HStack(spacing: 14) {
                            Circle()
                                .stroke(lineWidth: 4)
                                .frame(width: userInfoPresentationDetent == .medium ? 80 : 140, height: userInfoPresentationDetent == .medium ? 80 : 140)
                                .foregroundColor(.white)
                                .blur(radius: 3)
                                .overlay {
                                    KFImage(URL(string: viewModel.userInfo?.avatarURL ?? ""))
                                        .placeholder {
                                            Image(systemName: "person.crop.circle")
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .shadow(color: Color(hex: "33ABFF"), radius: 3, x: 3, y: 3)
                                }
                            VStack(alignment: .leading,spacing: 0) {
                                if let bio = viewModel.userInfo?.bio {
                                    Text(bio)
                                        .font(.system(size: 14, weight: .semibold))
                                        .lineLimit(4)
                                }
                                if let name = viewModel.userInfo?.name {
                                    Text(name)
                                        .font(.system(size: 22, weight: .semibold))
                                }
                                if let login = viewModel.userInfo?.login {
                                    Text(login)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(hex: "000072").opacity(0.7))
                                }
                            }
                            .foregroundColor(Color(hex: "000072"))
                            Spacer()
                        }
                        .padding([.bottom, .leading], 20)
                        .offset(y: userInfoPresentationDetent == .medium ? -120 : 0)
                    }
                }
            if let userInfo = viewModel.userInfo {
                if userInfo.following != .zero || userInfo.followers != .zero {
                    HStack {
                        Image(systemName: "person.2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                            .fontWeight(.medium)
                        
                        if userInfo.followers != .zero {
                            Text("\(userInfo.followers)").font(.system(size: 16, weight: .bold)) + Text(" follower").font(.system(size: 16))
                        }
                        
                        if userInfo.following != .zero {
                            Text("\(userInfo.following)").font(.system(size: 16, weight: .bold)) + Text(" following").font(.system(size: 16))
                        }
                    }
                    .foregroundColor(Color(hex: "000072"))
                    .padding(.leading, 20)
                    .offset(y: userInfoPresentationDetent == .medium ? -120 : 0)
                }
                
                VStack(alignment: .leading) {
                    if let location = userInfo.location, !location.isEmpty {
                        HStack {
                            Image(systemName: "location.north")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .fontWeight(.regular)
                            Text(location).font(.system(size: 16))
                        }
                    }
                    
                    if let company = userInfo.company, !company.isEmpty {
                        HStack {
                            Image(systemName: "building.2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .fontWeight(.regular)
                            Text(company).font(.system(size: 16))
                        }
                    }
                    
                    if let email = userInfo.email, !email.isEmpty {
                        HStack {
                            Image(systemName: "envelope")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .fontWeight(.medium)
                            Text(email).font(.system(size: 16))
                        }
                    }
                    
                    if let twitterUsername = userInfo.twitterUsername, !twitterUsername.isEmpty {
                        HStack {
                            Image(systemName: "bird")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .fontWeight(.semibold)
                            Text(twitterUsername).font(.system(size: 16))
                        }
                    }
                    
                    if let blog = userInfo.blog, !blog.isEmpty {
                        HStack {
                            Image(systemName: "link")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .fontWeight(.semibold)
                            Text(blog).font(.system(size: 16))
                        }
                    }
                }
                .offset(y: userInfoPresentationDetent == .medium ? -120 : 0)
                .foregroundColor(Color(hex: "000072"))
                .padding(.leading, 20)
            }
            
            if !viewModel.mostPopularRepos.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Popular")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "000072"))
                        .padding(.leading)
                        .padding(.bottom, 6)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .firstTextBaseline) {
                            ForEach(viewModel.mostPopularRepos, id: \.id) { item in
                                RepositoryCell(paddingHorizontal: paddingHorizontal, repoModel: item, presentationMode: .medium)
                                    .frame(width: UIScreen.width - 100)
                                    .padding(.trailing, 4)
                                    .padding(.top, 1)
                                    .padding(.bottom, 6)
                            }
                        }
                        .padding([.leading, .bottom, .trailing])
                    }
                }
                .offset(y: userInfoPresentationDetent == .medium ? UIScreen.height : 0)
                .padding(.top, 20)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Overview")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "000072"))
                    .padding(.bottom, 6)
                
                HStack {
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .fontWeight(.medium)
                    
                    Text("Repositories").font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text("\(viewModel.totalRepos)").font(.system(size: 16, weight: .bold))
                }
                
                HStack {
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .fontWeight(.medium)
                    
                    Text("Starred").font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text("\(viewModel.starred)").font(.system(size: 16, weight: .bold))
                }
            }
            .foregroundColor(Color(hex: "000072"))
            .padding()
            .offset(y: userInfoPresentationDetent == .medium ? -290 : 0)
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $sharedSheetPresented, content: {
            if let userUrlString = viewModel.userInfo?.htmlURL, let url = URL(string: userUrlString) {
                ActivityControllerView(activityItems: [url])
                    .presentationDetents([.medium, .large])
            }
        })
        .presentationDetents([.medium, .large], selection: $userInfoPresentationDetent)
        .animation(.easeInOut, value: userInfoPresentationDetent)
    }
}

#Preview {
    RepositoriesView(viewModel: .init(diContainer: .manager))
}
