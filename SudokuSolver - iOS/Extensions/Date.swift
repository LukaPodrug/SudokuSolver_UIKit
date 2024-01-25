//
//  Date.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
}
