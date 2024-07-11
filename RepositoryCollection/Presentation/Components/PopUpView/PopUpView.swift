//
//  PopUpView.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/07/2024.
//

import Foundation
import SwiftUI

struct PopUpView<PopUpContent>: ViewModifier where PopUpContent: View {
    
    @Binding var isPresented: Bool
    var content: () -> PopUpContent
    
    // MARK: - Private Properties
    @State private var presenterContentRect: CGRect = .zero
    
    @State private var sheetContentRect: CGRect = .zero
    
    private var displayedOffset: CGFloat {
        -presenterContentRect.midY + screenHeight / 2
    }
    
    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return 1000
        }
        return screenHeight - presenterContentRect.midY + sheetContentRect.height / 2 + 5
    }
    
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)
                .opacity(isPresented ? 0.1 : 1)
                .contentShape(Rectangle())
                .simultaneousGesture(
                    TapGesture().onEnded {
                        dismiss()
                    })
        }
        .overlay(sheet())
    }
    
    func sheet() -> some View {
        ZStack {
            if !isPresented {
                EmptyView()
            } else {
                ZStack {
                    self.content()
                        .frameGetter($sheetContentRect)
                        .frame(width: screenWidth)
                        .offset(x: 0, y: currentOffset)
                        .animation(Animation.easeOut(duration: 0.3), value: currentOffset)
                }
            }
        }
    }
    
    private func dismiss() {
        isPresented = false
    }
}

struct FrameGetter: ViewModifier {
    
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            )
    }
}

extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}
