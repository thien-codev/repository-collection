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
    @State var height: CGFloat = 50
    @State var backgroundColor: Color = .gray
    @State var tint: Color = .white
    
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
            .stroke(lineWidth: isEnabled ? 2 : 0)
            .foregroundColor(backgroundColor)
            .frame(height: height)
            .background {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .frame(height: height)
                    .foregroundColor(backgroundColor.opacity(0.3))
            }
            .overlay {
                HStack {
                    TextField(placeholder, text: $text) { isEnabled in
                        self.isEnabled = isEnabled
                    }
                    .accentColor(tint)
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
                .padding()
            }
            .animation(.easeInOut, value: isEnabled)
    }
}

#Preview {
    @State var text: String = .init()
    return CustomTextField(text: $text, isEnabled: .constant(true))
}
