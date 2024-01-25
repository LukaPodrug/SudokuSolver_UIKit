//
//  DonutChart.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 26.12.2023..
//

import Foundation
import SwiftUI
import Charts

struct DonutChart: View {
    let statistics: [StatisticModel]
    
    var body: some View {
        Chart(statistics) { statistic in
            SectorMark(
                angle: .value(
                    Text(verbatim: statistic.title),
                    statistic.value
                ),
                innerRadius: .ratio(0.7),
                angularInset: 1.5
            )
            .cornerRadius(5)
            .foregroundStyle(statistic.color)
        }
    }
}
