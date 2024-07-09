//
//  SettingView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 08/07/2024.
//

import Foundation
import SwiftUI

public enum AppIcon: String, CaseIterable, Codable {
    case initial
    case first
    case second
    case third
    
    var name: String {
        switch self {
        case .initial:
            return "AppIcon"
        case .first:
            return "AppIcon-1"
        case .second:
            return "AppIcon-2"
        case .third:
            return "AppIcon-3"
        }
    }
    
    var icon: String {
        switch self {
        case .initial:
            return "app-ic"
        case .first:
            return "app-ic-1"
        case .second:
            return "app-ic-2"
        case .third:
            return "app-ic-3"
        }
    }
    
    var title: String {
        switch self {
        case .initial:
            return "White"
        case .first:
            return "Black"
        case .second:
            return "Rainbow"
        case .third:
            return "Yellow"
        }
    }
}

struct SettingView: GeneralView {
    
    @State var appIcon: AppIcon = .initial
    @State var appIconPresented: Bool = false
    @State var userInfoPresentationDetent: PresentationDetent = .height(120)
    
    var appIconWidth: CGFloat {
        return (UIScreen.width - 20 * 2 - 12 * CGFloat(AppIcon.allCases.count - 1)) / 4
    }
    
    @ObservedObject var viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("General").font(.system(size: 16, weight: .semibold))
            HStack {
                Image(systemName: "smiley")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .fontWeight(.medium)
                Text("App icon").font(.system(size: 16, weight: .medium))
                
                Spacer()
                Text(viewModel.appIcon.title).font(.system(size: 16, weight: .medium))
                Image(viewModel.appIcon.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .mask {
                        RoundedRectangle(cornerRadius: 8)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                    }
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 12)
                    .fontWeight(.bold)
            }
            .padding(.top, 6)
            .contentShape(Rectangle())
            .onTapGesture {
                appIconPresented = true
            }
            Divider()
            Spacer()
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $appIconPresented, onDismiss: { userInfoPresentationDetent = .height(120) }) {
            appIconView
        }
    }
}

private extension SettingView {
    var appIconView: some View {
        VStack(alignment: .center) {
            if userInfoPresentationDetent == .medium {
                VStack(spacing: 12) {
                    ForEach(AppIcon.allCases, id: \.name) { item in
                        HStack(spacing: 16) {
                            drawIcon(item)
                            Text(item.title.uppercasedFirstLetter()).font(.system(size: 18, weight: .semibold))
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            changeAppIcon(to: item)
                        }
                    }
                    
                }
                .padding(20)
            } else {
                HStack(spacing: 12) {
                    ForEach(AppIcon.allCases, id: \.name) { item in
                        drawIcon(item)
                            .onTapGesture {
                                changeAppIcon(to: item)
                            }
                    }
                }
                .padding(20)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .presentationDetents([.height(120), .medium], selection: $userInfoPresentationDetent)
        .animation(.easeInOut, value: userInfoPresentationDetent)
    }
    
    func drawIcon(_ icon: AppIcon) -> some View {
        Image(icon.icon)
            .resizable()
            .scaledToFit()
            .frame(width: appIconWidth, height: appIconWidth)
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .shadow(radius: 2, x: 2, y: 2)
            }
    }
    
    func changeAppIcon(to appIcon: AppIcon) {
        UIApplication.shared.setAlternateIconName(appIcon.name) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                viewModel.trigger(.changeAppIconSuccess(appIcon))
            }
        }
    }
}
