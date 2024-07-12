//
//  ChartView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 10/07/2024.
//

import Foundation
import SwiftUI
import Charts

struct ChartView: View {
    
    @State private var chartSelection: Date?
    @Binding var previousChartSelection: Date?
    var displayData: [UserEventUIModel]
    var isShowedInDetail: Bool = false
    @Binding var showChartDetail: Bool
    @Binding var frameGetter: CGRect
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0)])
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if isShowedInDetail {
                Chart {
                    ForEach(displayData, id: \.id) { data in
                        LineMark(x: .value("Day", data.createdDate, unit: .day),
                                 y: .value("Value", data.types.count))
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(x: .value("Day", data.createdDate, unit: .day),
                                  y: .value("Value", data.types.count))
                        .symbolSize(.init(width: 4, height: 4))
                        .interpolationMethod(.catmullRom)
                        .annotation(position: .top) {
                            Text("\(data.types.count)")
                                .font(.system(size: previousChartSelection.hasValue ? (isSameDay(with: data.createdDate) ? 19 : 12) : 14, weight: .semibold))
                                .foregroundColor(isSameDay(with: data.createdDate) ? .white : .gray)
                                .background {
                                    if (isSameDay(with: data.createdDate)) {
                                        Text("\(data.types.count)")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                    }
                                }
                        }
                        
                        AreaMark(x: .value("Day", data.createdDate, unit: .day),
                                 y: .value("Value", data.types.count))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(areaBackground)
                    }
                }
                .chartXSelection(value: $chartSelection)
                .chartForegroundStyleScale(type: .linear)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel(format: .dateTime.day(.twoDigits).month(.abbreviated), centered: true)
                            .foregroundStyle(Color.gray)
                    }
                }
                .chartScrollableAxes(.horizontal)
                .frame(height: frameGetter.height)
            } else {
                Chart {
                    ForEach(displayData, id: \.id) { data in
                        LineMark(x: .value("Day", data.createdDate, unit: .day),
                                 y: .value("Value", data.types.count))
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(x: .value("Day", data.createdDate, unit: .day),
                                  y: .value("Value", data.types.count))
                        .symbolSize(.init(width: 4, height: 4))
                        .interpolationMethod(.catmullRom)
                        .annotation(position: .top) {
                            Text("\(data.types.count)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        
                        AreaMark(x: .value("Day", data.createdDate, unit: .day),
                                 y: .value("Value", data.types.count))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(areaBackground)
                    }
                }
                .chartXSelection(value: $chartSelection)
                .chartForegroundStyleScale(type: .linear)
                .chartScrollableAxes(.horizontal)
                .frameGetter($frameGetter)
            }
        }
        .onChange(of: chartSelection) { oldValue, newValue in
            guard newValue.hasValue else { return }
            previousChartSelection = newValue
            guard !showChartDetail else { return }
            showChartDetail = true
        }
        .padding(.horizontal)
    }
    
    func isSameDay(with date: Date) -> Bool {
        return previousChartSelection?.isSameDate(to: date) == true
    }
}
