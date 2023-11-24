//
//  LoadingView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import SwiftUI

struct LoadingView<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(isShowing)
                    .overlay(Color.black.opacity(isShowing ? 0.3 : 0))
                
                VStack {
                    ProgressView()
                }
                .frame(width: 50,
                       height: 50)
                .background(Color.white)
                .cornerRadius(6)
                .shadow(radius: 10)
                .opacity(isShowing ? 1 : 0)
            }
        }
    }
}

#Preview {
    LoadingView(isShowing: .constant(true)) {
        Color.white.ignoresSafeArea()
    }
}

