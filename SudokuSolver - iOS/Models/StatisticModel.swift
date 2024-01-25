//
//  StatisticModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 26.12.2023..
//

import Foundation
import SwiftUI

struct StatisticModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let value: Int
    let color: Color
}
