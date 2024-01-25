//
//  EditProfileViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.01.2024..
//

import Foundation

protocol EditProfileViewModelParentDelegate: AnyObject {
    func updateOwnDataAfterEditProfile()
}

protocol EditProfileViewModelDelegate: AnyObject {
    func updateOwnData(ownData: UserModel)
    func updateNationalityData(name: String, code: String, row: Int)
    func getEditProfileFormData() -> EditProfileFormModel
    func showNationalityPickerModal(nationalityRow: Int)
    func showEditProfileSuccessAlert()
    func showEditProfileFailureAlert()
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
}

class EditProfileViewModel {
    var ownData: UserModel
    var editProfileFormData: EditProfileFormModel
    
    weak var editProfileViewModelParentDelegate: EditProfileViewModelParentDelegate?
    weak var editProfileViewModelDelegate: EditProfileViewModelDelegate?
    
    init(ownData: UserModel) {
        self.ownData = ownData
        self.editProfileFormData = EditProfileFormModel(firstName: "", lastName: "", username: "", email: "", nationalityEntered: false, nationality: "", dateOfBirthEntered: false, dateOfBirth: Date())
    }
    
    func setup() {
        editProfileViewModelDelegate?.updateOwnData(ownData: ownData)
    }
    
    func editProfile() {
        DispatchQueue.main.async {
            self.editProfileFormData = (self.editProfileViewModelDelegate?.getEditProfileFormData())!
            
            Task {
                let (editProfileValid, editProfileMessage) = await APIManager.shared.editProfile(firstName: self.editProfileFormData.firstName, lastName: self.editProfileFormData.lastName, username: self.editProfileFormData.username, email: self.editProfileFormData.email, nationalityEntered: self.editProfileFormData.nationalityEntered, nationality: self.editProfileFormData.nationality, dateOfBirthEntered: self.editProfileFormData.dateOfBirthEntered, dateOfBirth: self.editProfileFormData.dateOfBirth)

                switch editProfileValid {
                    case .valid:
                        self.handleEditProfileSuccess()
                        break
                    case .invalid:
                        self.handleEditProfileFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleEditProfileSuccess() {
        editProfileViewModelParentDelegate?.updateOwnDataAfterEditProfile()
        editProfileViewModelDelegate?.hideModal(completion: editProfileViewModelDelegate?.showEditProfileSuccessAlert)
    }
    
    func handleEditProfileFailure() {
        editProfileViewModelDelegate?.hideModal(completion: editProfileViewModelDelegate?.showEditProfileFailureAlert)
    }
}

extension EditProfileViewModel: ProfileFormViewModelParentDelegate {
    func keyboardWillShow(notification: NSNotification) {
        editProfileViewModelDelegate?.keyboardWillShow(notification: notification)
    }
    
    func keyboardWillHide() {
        editProfileViewModelDelegate?.keyboardWillHide()
    }
    
    func showNationalityPickerModal(nationalityRow: Int) {
        editProfileViewModelDelegate?.showNationalityPickerModal(nationalityRow: nationalityRow)
    }
}

extension EditProfileViewModel: NationalityPickerViewModelParentDelegate {
    func selectNationality(name: String, code: String, row: Int) {
        editProfileViewModelDelegate?.updateNationalityData(name: name, code: code, row: row)
    }
    
    func hideNationalityPickerModal() {
        editProfileViewModelDelegate?.hideModal(completion: nil)
    }
}
