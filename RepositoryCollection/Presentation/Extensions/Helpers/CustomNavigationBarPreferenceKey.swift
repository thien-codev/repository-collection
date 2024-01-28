//
//  CustomNavigationBarPreferenceKey.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 28/01/2024.
//

import Foundation
import SwiftUI

struct CustomNavigationBarTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = .init()
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavigationBarBackButtonHiddenPreferenceKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct CustomNavigationBarShadowHiddenPreferenceKey: PreferenceKey {
    
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct CustomNavigationBarBackgroundColorPreferenceKey: PreferenceKey {
    
    static var defaultValue: Color = .white
    
    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }
}

struct CustomNavigationBarTintColorPreferenceKey: PreferenceKey {
    
    static var defaultValue: Color = .black
    
    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }
}

struct CustomNavigationBarRightItemPreferenceKey: PreferenceKey {
    
    static var defaultValue: EquatableViewContainer = .init(view: AnyView(EmptyView()))
    
    static func reduce(value: inout EquatableViewContainer, nextValue: () -> EquatableViewContainer) {
        value = nextValue()
    }
}

struct EquatableViewContainer: Equatable {
    
    let id = UUID().uuidString
    let view: AnyView
    
    static func == (lhs: EquatableViewContainer, rhs: EquatableViewContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    func customNavigationViewTitle(_ title: String) -> some View {
        preference(key: CustomNavigationBarTitlePreferenceKey.self, value: title)
    }
    
    func customNavigationViewBackButtonHidden(_ hidden: Bool) -> some View {
        preference(key: CustomNavigationBarBackButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func customNavigationViewShadowHidden(_ hidden: Bool) -> some View {
        preference(key: CustomNavigationBarShadowHiddenPreferenceKey.self, value: hidden)
    }
    
    func customNavigationViewBackgroundColor(_ color: Color) -> some View {
        preference(key: CustomNavigationBarBackgroundColorPreferenceKey.self, value: color)
    }
    
    func customNavigationViewTintColor(_ color: Color) -> some View {
        preference(key: CustomNavigationBarTintColorPreferenceKey.self, value: color)
    }
    
    func customNavigationViewRightItem(_ anyView: EquatableViewContainer) -> some View {
        preference(key: CustomNavigationBarRightItemPreferenceKey.self, value: anyView)
    }
}

