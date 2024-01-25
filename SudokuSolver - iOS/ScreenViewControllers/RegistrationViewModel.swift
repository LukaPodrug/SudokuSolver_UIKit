//
//  RegistrationViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 11.01.2024..
//

import Foundation

protocol RegistrationViewModelDelegate: AnyObject {
    func updateNationalityData(name: String, code: String, row: Int)
    func getRegistrationFormData() -> RegistrationFormModel
    func navigateToLogin()
    func navigateToProfile()
    func showNationalityPickerModal(nationalityRow: Int)
    func showRegistrationFailureAlert()
    func showSaveTokenFailureAlert()
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
}

class RegistrationViewModel {
    var registrationFormData: RegistrationFormModel
    
    weak var registrationViewModelDelegate: RegistrationViewModelDelegate?
    
    init() {
        self.registrationFormData = RegistrationFormModel(firstName: "", lastName: "", username: "", passwordPlaintext: "", email: "", nationalityEntered: false, nationality: "", dateOfBirthEntered: false, dateOfBirth: Date())
    }
    
    func navigateToLogin() {
        registrationViewModelDelegate?.navigateToLogin()
    }
    
    func registration() {
        DispatchQueue.main.async {
            self.registrationFormData = (self.registrationViewModelDelegate?.getRegistrationFormData())!
            
            Task {
                let (registrationValid, registrationMessage, registrationData) = await APIManager.shared.registration(firstName: self.registrationFormData.firstName, lastName: self.registrationFormData.lastName, username: self.registrationFormData.username, passwordPlaintext: self.registrationFormData.passwordPlaintext, email: self.registrationFormData.email, nationalityEntered: self.registrationFormData.nationalityEntered, nationality: self.registrationFormData.nationality, dateOfBirthEntered: self.registrationFormData.dateOfBirthEntered, dateOfBirth: self.registrationFormData.dateOfBirth)
                
                switch registrationValid {
                    case .valid:
                        self.handleRegistrationSuccess(token: registrationData!)
                        break
                    case .invalid:
                        self.handleRegistrationFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleRegistrationSuccess(token: String) {
        DispatchQueue.main.async {
            let (saveTokenVaild, saveTokenMessage) = KeychainManager.shared.save(service: "token", account: "user", token: token.data(using: .utf8)!)
            
            switch saveTokenVaild {
                case .valid:
                    self.handleSaveTokenSuccess()
                    break
                case .invalid:
                    self.handleSaveTokenFailure()
                    break
                default:
                    break
            }
        }
    }
    
    func handleRegistrationFailure() {
        registrationViewModelDelegate?.hideModal(completion: registrationViewModelDelegate?.showRegistrationFailureAlert)
    }
    
    func handleSaveTokenSuccess() {
        registrationViewModelDelegate?.hideModal(completion: registrationViewModelDelegate?.navigateToProfile)
    }
    
    func handleSaveTokenFailure() {
        registrationViewModelDelegate?.showSaveTokenFailureAlert()
    }
}

extension RegistrationViewModel: ProfileFormViewModelParentDelegate {
    func keyboardWillShow(notification: NSNotification) {
        registrationViewModelDelegate?.keyboardWillShow(notification: notification)
    }
    
    func keyboardWillHide() {
        registrationViewModelDelegate?.keyboardWillHide()
    }
    
    func showNationalityPickerModal(nationalityRow: Int) {
        registrationViewModelDelegate?.showNationalityPickerModal(nationalityRow: nationalityRow)
    }
}

extension RegistrationViewModel: NationalityPickerViewModelParentDelegate {
    func selectNationality(name: String, code: String, row: Int) {
        registrationViewModelDelegate?.updateNationalityData(name: name, code: code, row: row)
    }
    
    func hideNationalityPickerModal() {
        registrationViewModelDelegate?.hideModal(completion: nil)
    }
}
