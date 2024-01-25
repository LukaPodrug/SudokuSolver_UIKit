//
//  AttemptModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 01.01.2024..
//

import Foundation

struct AddAttemptModel: Codable {
    let puzzleId: Int
    let completion: Bool
    let time: Int
}
