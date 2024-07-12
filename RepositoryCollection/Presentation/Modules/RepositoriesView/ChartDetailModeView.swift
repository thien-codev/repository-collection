//
//  ChartDetailModeView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 12/07/2024.
//

import Foundation
import SwiftUI
import Lottie

struct ChartDetailModeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var chartSelection: Date?
    @State private var previousChartSelection: Date?
    var displayData: [UserEventUIModel]
    var frameChart: CGRect
    var onClose: (() -> Void)?
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0)])
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    onClose?()
                }
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    if let date = previousChartSelection?.textInUTC {
                        HStack(alignment: .lastTextBaseline) {
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(.white)
                                        .blur(radius: 2)
                                }
                            
                            Text(date)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .background {
                                    Text(date)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .blur(radius: 2)
                                }
                            Spacer()
                        }
                        .isHidden(getDislayInfo(previousChartSelection).isEmpty, remove: true)
                    }
                    Text(getDislayInfo(previousChartSelection))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .background {
                            Text(getDislayInfo(previousChartSelection))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .blur(radius: 2)
                        }
                        .isHidden(!previousChartSelection.hasValue, remove: true)
                }
                .padding(.horizontal)
                ChartView(previousChartSelection: $previousChartSelection, displayData: displayData, isShowedInDetail: true, showChartDetail: .constant(true), frameGetter: .constant(frameChart))
                    .overlay {
                        HStack {
                            handTapView
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(135))
                                .padding(.leading, 20)
                                .padding(.bottom, 60)
                            Spacer()
                        }
                        .isHidden(previousChartSelection.hasValue, remove: true)
                    }
            }
        }
    }
}

private extension ChartDetailModeView {
    var handTapView: some View {
        let path = Bundle.main.path(forResource: "hand-tapping",
                                    ofType: "json") ?? ""
        let animationView = LottieView(animation: .filepath(path))
        return animationView.playing(loopMode: .loop)
    }
    
    func getDislayInfo(_ selectedDate: Date?) -> String {
        guard let selectedDate else { return "" }
        return displayData.first(where: { $0.createdDate.isSameDate(to: selectedDate) })?.message ?? ""
    }
}
