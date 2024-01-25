//
//  PuzzleSolutionMenuModelView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol PuzzleSolutionMenuViewParentDelegate: AnyObject {
    func showNextStep()
    func showEntireSolution()
}

class PuzzleSolutionMenuViewModel {
    weak var puzzleSolutionMenuViewParentDelegate: PuzzleSolutionMenuViewParentDelegate?
    
    func showNextStep() {
        puzzleSolutionMenuViewParentDelegate?.showNextStep()
    }
    
    func showEntireSolution() {
        puzzleSolutionMenuViewParentDelegate?.showEntireSolution()
    }
}
