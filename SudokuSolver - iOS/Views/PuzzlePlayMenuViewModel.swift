//
//  PuzzlePlayMenuViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol PuzzlePlayMenuViewParentDelegate: AnyObject {
    func clearPuzzle()
    func deleteCell()
    func toggleNotes()
}

class PuzzlePlayMenuViewModel {
    weak var puzzlePlayMenuViewParentDelegate: PuzzlePlayMenuViewParentDelegate?
    
    func clearPuzzle() {
        puzzlePlayMenuViewParentDelegate?.clearPuzzle()
    }
    
    func deleteCell() {
        puzzlePlayMenuViewParentDelegate?.deleteCell()
    }
    
    func toggleNotes() {
        puzzlePlayMenuViewParentDelegate?.toggleNotes()
    }
}
