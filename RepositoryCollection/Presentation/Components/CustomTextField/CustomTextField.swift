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
    @State var frame: CGRect = .zero
    @Binding var isLoading: Bool
    @State var ratioLoadingView: CGFloat = 0
    var focusKeyboard: FocusState<Bool>.Binding
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20.0)
            .stroke(lineWidth: 1)
            .foregroundColor(tint)
            .frame(height: height)
            .background {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(backgroundColor)
                    Rectangle()
                        .frame(width: ratioLoadingView == 0 ? 0 : frame.width * ratioLoadingView)
                        .foregroundColor(.blue.opacity(0.6).opacity(ratioLoadingView == 0 || ratioLoadingView == 1 ? 0 : CGFloat(1 - ratioLoadingView * 0.8)))
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
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
            .onChange(of: isLoading, { oldValue, newValue in
                if newValue {
                    let timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { _ in
                        guard ratioLoadingView != 1, isLoading else { return }
                        ratioLoadingView += 0.2
                    })
                    RunLoop.main.add(timer, forMode: .common)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        ratioLoadingView = 1
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        ratioLoadingView = 0
                    })
                }
            })
            .animation(.easeInOut, value: isEnabled)
            .animation(.easeInOut, value: frame)
            .animation(.linear(duration: 0.2), value: ratioLoadingView)
            .frameGetter($frame)
    }
}
