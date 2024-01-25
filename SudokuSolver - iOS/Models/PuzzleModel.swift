//
//  PuzzleModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 22.12.2023..
//

import Foundation

struct PuzzleModel: Codable {
    let id: Int
    let string: String
    let solvedString: String
    let difficulty: Int
    let creationDate: String
    let creationUserId: Int
    let recordUserId: Int?
    let recordTime: Int?
    let recordDate: String?
    let totalSuccessAttempts: Int
    let totalFailureAttempts: Int
    let userSuccessAttempts: Int
    let userFailureAttempts: Int
}

struct AddPuzzleModel: Codable {
    let string: String
}
