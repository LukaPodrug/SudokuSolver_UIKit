//
//  String.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import Foundation

extension String? {
    func toDateString() -> String {
        if self == nil || self == "" {
            return "-"
        }
        
        let dateFormatter1: DateFormatter = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        let dateObject = dateFormatter1.date(from: self!)!
        
        let dateFormatter2: DateFormatter = DateFormatter()
        
        dateFormatter2.dateStyle = .medium
        dateFormatter2.timeStyle = .none
        
        return dateFormatter2.string(from: dateObject)
    }
    
    func toDate() -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: (self!))!
    }
}

extension String {
    func toDateString() -> String {
        if self == "" {
            return "-"
        }
        
        let dateFormatter1: DateFormatter = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        let dateObject = dateFormatter1.date(from: self)!
        
        let dateFormatter2: DateFormatter = DateFormatter()
        
        dateFormatter2.dateStyle = .medium
        dateFormatter2.timeStyle = .none
        
        return dateFormatter2.string(from: dateObject)
    }
    
    func toPuzzleMatrix() -> [[Int]] {
        var puzzleMatrix: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        var workingString: String = self
        
        for index in 0...80 {
            puzzleMatrix[index / 9][index % 9] = Int(String((workingString.first)!))!
            
            workingString = String(workingString.dropFirst())
        }
        
        return puzzleMatrix
    }
    
    func toCandidatesMatrix() -> [[[Int]]] {
        var candidatesMatrix: [[[Int]]] = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9), count: 9)
        var workingString: String = self
        
        for index in 0...728 {
            candidatesMatrix[index / 81][(index / 9) % 9][index % 9] = Int(String((workingString.first)!))!
            
            workingString = String(workingString.dropFirst())
        }
        
        return candidatesMatrix
    }
    
    func toInt() -> Int {
        if self == "" {
            return 0
        }
        
        return Int(self)!
    }
}
