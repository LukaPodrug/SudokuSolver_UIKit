//
//  StandingModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 04.01.2024..
//

import Foundation

struct StandingModel: Codable, Hashable {
    let id: Int
    let username: String
    let points: Int
    let standing: Int
}
