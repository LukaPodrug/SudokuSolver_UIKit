//
//  [[Int]].swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 09.01.2024..
//

import Foundation

extension [[Int]] {
    func toPuzzleString() -> String {
        var puzzleString = ""
        
        for index in 0...80 {
            puzzleString = puzzleString + String(self[index / 9][index % 9])
        }
        
        return puzzleString
    }
}
