//
//  CustomNavigationView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 28/01/2024.
//

import Foundation
import SwiftUI

struct CustomNavigationView<Content> : View where Content : View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView(content: {
            CustomNavigationContainerView {
                content
            }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CustomNavigationView {
        Text("Destination")
    }
}
