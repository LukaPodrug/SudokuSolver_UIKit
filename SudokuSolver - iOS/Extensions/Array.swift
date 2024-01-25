//
//  Array.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 04.01.2024..
//

import Foundation

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
