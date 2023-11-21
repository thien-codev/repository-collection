//
//  OnboardingView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    
    @State var animated: Bool = false
    @State var userID: String = .init()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                wave()
                    .foregroundColor(.blue.opacity(0.9))
                    .offset(x: animated ? -UIScreen.width : 0)
                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: animated)
                
                wave(waveHeight: 200,
                     waveDeep: 100)
                .foregroundColor(.blue.opacity(0.6))
                .offset(x: animated ? -UIScreen.width : 0)
                .animation(.linear(duration: 6).repeatForever(autoreverses: false), value: animated)
                
                wave(waveHeight: 250,
                     waveDeep: 250)
                .foregroundColor(.blue.opacity(0.4))
                .offset(x: animated ? -UIScreen.width : 0, y: -60)
                .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: animated)
                
                HStack {
                    CustomTextField(placeholder: "UserID", text: $userID)
                    enterButton
                }
                .animation(.easeInOut, value: userID)
                .padding()
            }
            .onAppear {
                animated.toggle()
            }
        }
    }
    
    func wave(baseline: CGFloat = UIScreen.height / 2, 
              waveHeight: CGFloat = 100,
              waveDeep: CGFloat = 100) -> Path {
        Path { path in
            let topLeftPoint = CGPoint(x: 0, y: baseline)
            let topMiddlePoint = CGPoint(x: UIScreen.width, y: baseline)
            let topRightPoint = CGPoint(x: 2 * UIScreen.width, y: baseline)
            
            let bottomRightPoint = CGPoint(x: 2 * UIScreen.width, y: 2 * baseline)
            let bottomLeftPoint = CGPoint(x: 0, y: 2 * baseline)
            
            let firstControl1Point = CGPoint(x: UIScreen.width / 4, y: baseline - waveHeight)
            let firstControl2Point = CGPoint(x: UIScreen.width * 3 / 4, y: baseline + waveDeep)
            
            let secondControl1Point = CGPoint(x: UIScreen.width * 5 / 4, y: baseline - waveHeight)
            let secondControl2Point = CGPoint(x: UIScreen.width * 7 / 4, y: baseline + waveDeep)
            
            path.move(to: topLeftPoint)
            
            path.addCurve(to: topMiddlePoint, control1: firstControl1Point, control2: firstControl2Point)
            path.addCurve(to: topRightPoint, control1: secondControl1Point, control2: secondControl2Point)
            
            path.addLine(to: bottomRightPoint)
            path.addLine(to: bottomLeftPoint)
        }
    }
    
    var enterButton: some View {
        NavigationLink {
            RepositoriesView()
                .navigationBarBackButtonHidden(true)
        } label: {
            Circle()
                .foregroundColor(.gray)
                .overlay {
                    Image(systemName: "arrowshape.right.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundColor(.white)
                }
                .frame(width: userID.isEmpty ? 0 : 50)
        }
    }
}

#Preview {
    OnboardingView()
}
