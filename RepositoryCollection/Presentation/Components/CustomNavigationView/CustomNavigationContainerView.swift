//
//  CustomNavigationContainerView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 28/01/2024.
//

import SwiftUI

struct CustomNavigationContainerView<Content: View>: View {
    
    private let content: Content
    
    @State var title: String = .init()
    @State var backButtonHidden: Bool = false
    @State var rightItem: EquatableViewContainer? = nil
    @State var backgroundColor: Color = .white
    @State var tintColor: Color = .black
    @State var shadowHidden: Bool = true
    @State var barHidden: Bool = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !barHidden {
                CustomNavigationBar(title: title,
                                    backButtonHidden: backButtonHidden,
                                    shadowHidden: shadowHidden,
                                    backgroundColor: backgroundColor,
                                    tintColor: tintColor,
                                    rightItem: rightItem)
            }
            content.frame(maxWidth: .infinity,
                          maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavigationBarTitlePreferenceKey.self, perform: { value in
            title = value
        })
        .onPreferenceChange(CustomNavigationBarBackButtonHiddenPreferenceKey.self, perform: { value in
            backButtonHidden = value
        })
        .onPreferenceChange(CustomNavigationBarShadowHiddenPreferenceKey.self, perform: { value in
            shadowHidden = value
        })
        .onPreferenceChange(CustomNavigationBarBackgroundColorPreferenceKey.self, perform: { value in
            backgroundColor = value
        })
        .onPreferenceChange(CustomNavigationBarTintColorPreferenceKey.self, perform: { value in
            tintColor = value
        })
        .onPreferenceChange(CustomNavigationBarRightItemPreferenceKey.self, perform: { value in
            rightItem = value
        })
        .onPreferenceChange(CustomNavigationBarHiddenPreferenceKey.self, perform: { value in
            barHidden = value
        })
    }
}

#Preview {
    CustomNavigationContainerView {
        Text("Hello, World!")
    }
}
