//
//  LoginFormViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol LoginFormViewModelParentDelegate: AnyObject {
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
}

protocol LoginFormViewModelDelegate: AnyObject {
    func getFormData() -> LoginFormModel
    func resetTextFieldValues()
    func resetTextFieldCursor()
}

class LoginFormViewModel {
    weak var loginFormViewModelParentDelegate: LoginFormViewModelParentDelegate?
    weak var loginFormViewModelDelegate: LoginFormViewModelDelegate?
    
    func keyboardWillShow(notification: NSNotification) {
        loginFormViewModelParentDelegate?.keyboardWillShow(notification: notification)
    }
    
    func keyboardWillHide() {
        loginFormViewModelParentDelegate?.keyboardWillHide()
    }
    
    func resetTextFieldValues() {
        loginFormViewModelDelegate?.resetTextFieldValues()
    }
    
    func resetTextFieldCursor() {
        loginFormViewModelDelegate?.resetTextFieldCursor()
    }
    
    func getFormData() -> LoginFormModel {
        return (loginFormViewModelDelegate?.getFormData())!
    }
}
