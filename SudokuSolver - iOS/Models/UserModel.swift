//
//  UserModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 21.12.2023..
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let username: String
    let email: String?
    let nationality: String?
    let dateOfBirth: String?
    let nationalityStanding: Int?
    let globalStanding: Int
    let successAttempts: Int
    let failureAttempts: Int
    let numberOfRecords: Int
}

struct EditUserModel: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let email: String?
    let nationality: String?
    let dateOfBirth: String?
}
