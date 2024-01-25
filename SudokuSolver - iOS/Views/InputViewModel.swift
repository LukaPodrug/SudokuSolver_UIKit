//
//  InputViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol InputViewModelParentDelegate: AnyObject {
    func showManualInputModal()
    func showGalleryInputModal()
    func showCameraInputModal()
}

class InputViewModel {
    weak var inputViewModelParentDelegate: InputViewModelParentDelegate?
    
    func showManualInput() {
        inputViewModelParentDelegate?.showManualInputModal()
    }
    
    func showGalleryInput() {
        inputViewModelParentDelegate?.showGalleryInputModal()
    }
    
    func showCameraInput() {
        inputViewModelParentDelegate?.showCameraInputModal()
    }
}
