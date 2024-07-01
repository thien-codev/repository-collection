//
//  WaveBackgroundView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import SwiftUI

struct WaveBackgroundView: View {
    
    @State var animated: Bool = false
    
    var body: some View {
        ZStack {
            wave()
                .foregroundColor(.blue.opacity(0.9))
                .offset(x: animated ? -UIScreen.width : 0)
                .animation(.linear(duration: 10).repeatForever(autoreverses: true), value: animated)
            
            wave(waveHeight: 140, waveDeep: 100)
                .foregroundColor(.blue.opacity(0.6))
                .offset(x: animated ? -UIScreen.width : 0)
                .animation(.linear(duration: 14).repeatForever(autoreverses: true), value: animated)
            
            wave(waveHeight: 100, waveDeep: 140)
                .foregroundColor(.blue.opacity(0.4))
                .offset(x: animated ? -UIScreen.width : 0, y: -60)
                .animation(.linear(duration: 7).repeatForever(autoreverses: true), value: animated)
        }
        .ignoresSafeArea()
        .onAppear {
            animated.toggle()
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
}

#Preview {
    WaveBackgroundView()
}
