//
//  ProfileFormViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol ProfileFormViewModelParentDelegate: AnyObject {
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
    func showNationalityPickerModal(nationalityRow: Int)
}

protocol ProfileFormViewModelDelegate: AnyObject {
    func getRegistrationFormData() -> RegistrationFormModel
    func getEditProfileFormData() -> EditProfileFormModel
    func updateNationalityTextFieldText(name: String)
    func resetTextFieldValues()
    func resetTextFieldCursor()
}

class ProfileFormViewModel {
    var nationalityCode: String
    var nationalityRow: Int
    var showPassword: Bool
    
    weak var profileFormViewModelParentDelegate: ProfileFormViewModelParentDelegate?
    weak var profileFormViewModelDelegate: ProfileFormViewModelDelegate?
    
    init(showPassword: Bool) {
        self.nationalityCode = ""
        self.nationalityRow = 0
        self.showPassword = showPassword
    }
    
    func keyboardWillShow(notification: NSNotification) {
        profileFormViewModelParentDelegate?.keyboardWillShow(notification: notification)
    }
    
    func keyboardWillHide() {
        profileFormViewModelParentDelegate?.keyboardWillHide()
    }
    
    func showNationalityPickerModal(nationalityRow: Int) {
        profileFormViewModelParentDelegate?.showNationalityPickerModal(nationalityRow: nationalityRow)
    }
    
    func updateNationalityCode(code: String) {
        nationalityCode = code
    }
    
    func updateNationalityRow(row: Int) {
        nationalityRow = row
    }
    
    func updateNationalityTextFieldText(name: String) {
        profileFormViewModelDelegate?.updateNationalityTextFieldText(name: name)
    }
    
    func resetTextFieldValues() {
        nationalityCode = ""
        nationalityRow = 0
        profileFormViewModelDelegate?.resetTextFieldValues()
    }
    
    func resetTextFieldCursor() {
        profileFormViewModelDelegate?.resetTextFieldCursor()
    }
    
    func getCountryNameAndRow(countryCode: String) -> (String, Int) {
        let localesList: [String] = NSLocale.isoCountryCodes
        
        var index: Int = 0
        
        for localeListItem in localesList {
            index = index + 1
            
            let localeIdentifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: localeListItem])
            let locale = NSLocale(localeIdentifier: localeIdentifier)
            let countryName = locale.displayName(forKey: NSLocale.Key.identifier, value: localeIdentifier)!
            
            if localeListItem == countryCode {
                return (countryName, index)
            }
        }
        
        return ("", 0)
    }
}
