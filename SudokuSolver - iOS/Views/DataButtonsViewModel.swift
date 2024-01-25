//
//  DataButtonsViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol DataButtonsViewModelParentDelegate: AnyObject {
    func showMyPuzzlesModal()
    func showStandingsModal()
    func showEditProfileModal()
}

class DataButtonsViewModel {
    weak var dataButtonsViewModelParentDelegate: DataButtonsViewModelParentDelegate?
    
    func showMyPuzzles() {
        dataButtonsViewModelParentDelegate?.showMyPuzzlesModal()
    }
    
    func showStandings() {
        dataButtonsViewModelParentDelegate?.showStandingsModal()
    }
    
    func showEditProfile() {
        dataButtonsViewModelParentDelegate?.showEditProfileModal()
    }
}
