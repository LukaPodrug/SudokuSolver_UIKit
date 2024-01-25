//
//  UserViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.01.2024..
//

import Foundation

protocol UserViewModelDelegate: AnyObject {
    func updateUserData()
    func showGetUserDataFailureAlert()
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
}

class UserViewModel {
    var userId: Int
    var userData: UserModel
    var setupDone: Bool
    
    weak var userViewModelDelegate: UserViewModelDelegate?
    
    init(userId: Int) {
        self.userId = userId
        self.userData = UserModel(id: 0, firstName: "", lastName: "", username: "", email: "", nationality: "", dateOfBirth: "", nationalityStanding: 0, globalStanding: 0, successAttempts: 0, failureAttempts: 0, numberOfRecords: 0)
        self.setupDone = false
    }
    
    func setup() async {
        DispatchQueue.main.async {
            if self.setupDone == false {
                self.userViewModelDelegate?.showLoadingModal()
                
                Task {
                    await self.getUserData()
                    self.setupDone = true
                }
            }
        }
    }
    
    func getUserData() async {
        DispatchQueue.main.async {
            Task {
                let (getUserDataValid, getUserDataMessage, getUserDataData) = await APIManager.shared.getUserData(userId: self.userId)

                switch getUserDataValid {
                    case .valid:
                        self.handleGetUserDataSuccess(userData: getUserDataData!)
                        break
                    case .invalid:
                        self.handleGetUserDataFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleGetUserDataSuccess(userData: UserModel) {
        self.userData = userData
        userViewModelDelegate?.updateUserData()
    }
    
    func handleGetUserDataFailure() {
        userViewModelDelegate?.hideModal(completion: userViewModelDelegate?.showGetUserDataFailureAlert)
    }
}
