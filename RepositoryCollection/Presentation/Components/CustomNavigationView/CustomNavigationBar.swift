//
//  CustomNavigationBar.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 27/01/2024.
//

import Foundation
import SwiftUI

struct CustomNavigationBar: View {
    
    enum BackButtonStyle: String {
        case arrow = "chevron.backward"
        case xmark = "xmark"
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var title: String = ""
    var height: CGFloat = 60
    var backButtonStyle: BackButtonStyle = .arrow
    var backButtonHidden: Bool = true
    var shadowHidden: Bool = true
    var backgroundColor: Color = .gray
    var tintColor: Color = .black
    var rightItem: EquatableViewContainer? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
            }
            HStack {
                if !backButtonHidden {
                    backButton
                }
                
                if let rightItem {
                    Spacer()
                    rightItem.view
                }
            }
        }
        .foregroundColor(tintColor)
        .padding([.leading, .trailing])
        .frame(height: height)
        .background {
            backgroundColor.ignoresSafeArea()
                .shadow(radius: shadowHidden ? 0 : 8,
                        x: 0 ,
                        y: shadowHidden ? 0 : 8)
        }
    }
}

private extension CustomNavigationBar {
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: backButtonStyle.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        })
    }
}

#Preview {
    VStack {
        let rightItem = Image(systemName: "info.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
        CustomNavigationBar(title: "Account",
                            backButtonStyle: .arrow,
                            rightItem: EquatableViewContainer(view: AnyView(rightItem)))
        Spacer()
    }
}
