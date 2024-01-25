//
//  AuthorizationModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.12.2023..
//

import Foundation

struct RegistrationModel: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let passwordPlaintext: String
    let email: String?
    let nationality: String?
    let dateOfBirth: String?
}

struct LoginModel: Codable {
    let username: String
    let passwordPlaintext: String
}
