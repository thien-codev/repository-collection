//
//  ChartView.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 10/07/2024.
//

import Foundation
import SwiftUI
import Charts

struct OverallData: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let coffee: Int
    
    static func mockData() -> [OverallData] {
        
        return [
            .init(date: Date(timeIntervalSinceNow: 1720581289), coffee: 12),
            .init(date: Date(timeIntervalSinceNow: 1720856710), coffee: 15),
            .init(date: Date(timeIntervalSinceNow: 1721115910), coffee: 8),
            .init(date: Date(timeIntervalSinceNow: 1721202310), coffee: 18),
            .init(date: Date(timeIntervalSinceNow: 1721288710), coffee: 14),
            .init(date: Date(timeIntervalSinceNow: 1721547910), coffee: 22),
        ]
    }
}

struct ChartView: View {
    
    @State private var chartSelection: Date?
    @State private var previousChartSelection: Date?
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0)])
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Chart {
                ForEach(OverallData.mockData(), id: \.self) { data in
                    BarMark(x: .value("Day", data.date, unit: .day),
                            y: .value("Value", data.coffee))
                    .annotation(position: .top) {
                        Text("\(data.coffee)").font(.system(size: previousChartSelection.hasValue ? (isSameDay(with: data.date) ? 18 : 10) : 14, weight: .semibold))
                    }
                    .cornerRadius(4)
                }
            }
            .chartXSelection(value: $chartSelection)
            
//            Text(previousChartSelection?.description ?? "")
//                .padding()
//                .background {
//                    RoundedRectangle(cornerRadius: 12)
//                        .foregroundColor(.white)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(lineWidth: 2)
//                        }
//                }
        }
        .onChange(of: chartSelection) { oldValue, newValue in
            guard newValue.hasValue else { return }
            previousChartSelection = newValue
        }
    }
    
    func isSameDay(with date: Date) -> Bool {
        return previousChartSelection?.isEqual(to: date) == true
    }
}
