//
//  View.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 08/06/2024.
//

import Foundation
import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    func popup<PopupContent: View>(isPresented: Binding<Bool>, view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            PopUpView(isPresented: isPresented, content: view)
        )
    }
}
