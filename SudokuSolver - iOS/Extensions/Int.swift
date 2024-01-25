//
//  Int.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import Foundation

extension Int? {
    func toString() -> String {
        if self == nil || self == 0 {
            return "-"
        }
        
        return String(self!)
    }
    
    func secondsToTime() -> String {
        if self == nil {
            return "-"
        }
        
        let hour = self! / 3600
        let minute = self! / 60 % 60
        let second = self! % 60

        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}

extension Int {
    func toString() -> String {
        if self == 0 {
            return "-"
        }
        
        return String(self)
    }
    
    func secondsToTime() -> String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}
