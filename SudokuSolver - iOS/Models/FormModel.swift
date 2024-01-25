//
//  FormModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import Foundation

struct LoginFormModel {
    let username: String
    let passwordPlaintext: String
}

struct RegistrationFormModel {
    let firstName: String
    let lastName: String
    let username: String
    let passwordPlaintext: String
    let email: String
    let nationalityEntered: Bool
    let nationality: String
    let dateOfBirthEntered: Bool
    let dateOfBirth: Date
}

struct EditProfileFormModel {
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let nationalityEntered: Bool
    let nationality: String
    let dateOfBirthEntered: Bool
    let dateOfBirth: Date
}
