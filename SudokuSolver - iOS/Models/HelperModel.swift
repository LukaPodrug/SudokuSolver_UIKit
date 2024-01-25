//
//  HelperModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 02.01.2024..
//

import Foundation

struct HelperModel: Codable {
    let id: Int
    let puzzleString: String
    let userString: String
    let solutionString: String
}
