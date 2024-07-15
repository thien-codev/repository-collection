//
//  CustomTextField.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    
    var placeholder: String = "Enter"
    @Binding var text: String
    @Binding var isEnabled: Bool
    @State var height: CGFloat = 40
    @State var backgroundColor: Color = .white
    @State var tint: Color = .gray
    var focusKeyboard: FocusState<Bool>.Binding
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20.0)
            .stroke(lineWidth: 1)
            .foregroundColor(tint)
            .frame(height: height)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: height)
                    .foregroundColor(backgroundColor)
                    .shadow(radius: 0, x: 8, y: 8)
            }
            .overlay {
                HStack(spacing: 4) {
                    Image("ic-github")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    TextField(placeholder, text: $text) { isEnabled in
                        self.isEnabled = isEnabled
                    }
                    .textFieldStyle(.plain)
                    .disableAutocorrection(true)
                    .focused(focusKeyboard)
                    .accentColor(tint)
                    .foregroundColor(tint)
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .fontWeight(.bold)
                        .foregroundColor(tint)
                        .opacity(text.isEmpty ? 0 : 1)
                        .onTapGesture {
                            text = .init()
                        }
                }
                .padding(.trailing)
                .padding(.leading, 6)
            }
            .animation(.easeInOut, value: isEnabled)
    }
}
