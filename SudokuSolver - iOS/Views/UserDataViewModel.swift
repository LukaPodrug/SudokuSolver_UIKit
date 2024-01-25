//
//  UserDataViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol UserDataViewModelDelegate: AnyObject {
    func updateUserData()
}

class UserDataViewModel {
    var userData: UserModel
    
    weak var userDataViewModelDelegate: UserDataViewModelDelegate?
    
    init() {
        self.userData = UserModel(id: 0, firstName: "", lastName: "", username: "", email: "", nationality: "", dateOfBirth: "", nationalityStanding: 0, globalStanding: 0, successAttempts: 0, failureAttempts: 0, numberOfRecords: 0)
    }
    
    func updateData(userData: UserModel) {
        self.userData = userData
        userDataViewModelDelegate?.updateUserData()
    }
}
