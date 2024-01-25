//
//  APIManager.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.12.2023..
//

import Foundation
import UIKit

enum APIValid: Error {
    case valid
    case missing
    case invalid
}

class APIManager {
    static let shared: APIManager = APIManager()
    
    let baseAPIURL: String = "https://sudokusolverapi.onrender.com"
    
    func verifyToken() async -> (valid: APIValid?, message: String?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid != .missing else {
            return (.missing, "Token not found")
        }
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token")
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/authorization" + "/verifyToken"
        let url: URL = URL(string: fullAPIURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        var verifyTokenValid: APIValid?
        var verifyTokenMessage: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                verifyTokenValid = .invalid
                verifyTokenMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode
            
            guard responseCode != 500 else {
                verifyTokenValid = .invalid
                verifyTokenMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                verifyTokenValid = .invalid
                verifyTokenMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                verifyTokenValid = .valid
                verifyTokenMessage = "Success"
                return
            }
            
            verifyTokenValid = .invalid
            verifyTokenMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (verifyTokenValid, verifyTokenMessage)
    }
    
    func registration(firstName: String, lastName: String, username: String, passwordPlaintext: String, email: String?, nationalityEntered: Bool, nationality: String?, dateOfBirthEntered: Bool, dateOfBirth: Date?) async -> (valid: APIValid?, message: String?, token: String?) {
        let fullAPIURL: String = baseAPIURL + "/authorization" + "/registration"
        let url: URL = URL(string: fullAPIURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var dateOfBirthString: String = ""
        var nationalityCode: String = ""
        
        if nationalityEntered {
            nationalityCode = (nationality?.uppercased())!
        }
        
        if dateOfBirthEntered {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateOfBirthString = dateFormatter.string(from: dateOfBirth!)
        }
        
        let message: RegistrationModel = RegistrationModel(
            firstName: firstName,
            lastName: lastName,
            username: username,
            passwordPlaintext: passwordPlaintext,
            email: email,
            nationality: nationalityCode,
            dateOfBirth: dateOfBirthString
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var registrationValid: APIValid?
        var registrationMessage: String?
        var registrationToken: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                registrationValid = .invalid
                registrationMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode
            
            guard responseCode != 500 else {
                registrationValid = .invalid
                registrationMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                registrationValid = .invalid
                registrationMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                registrationValid = .valid
                registrationMessage = "Success"
                registrationToken = String(decoding: data ?? Data(), as: UTF8.self)
                return
            }
            
            registrationValid = .invalid
            registrationMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (registrationValid, registrationMessage, registrationToken)
    }
    
    func login(username: String, passwordPlaintext: String) async -> (valid: APIValid?, message: String?, token: String?) {
        let fullAPIURL: String = baseAPIURL + "/authorization" + "/login"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let message: LoginModel = LoginModel(
            username: username,
            passwordPlaintext: passwordPlaintext
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var loginValid: APIValid?
        var loginMessage: String?
        var loginToken: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                loginValid = .invalid
                loginMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                loginValid = .invalid
                loginMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                loginValid = .invalid
                loginMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                loginValid = .valid
                loginMessage = "Success"
                loginToken = String(decoding: data ?? Data(), as: UTF8.self)
                return
            }
            
            loginValid = .invalid
            loginMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (loginValid, loginMessage, loginToken)
    }
    
    func getOwnData() async -> (valid: APIValid?, message: String?, data: UserModel?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/user" + "/ownData"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        var getOwnDataValid: APIValid?
        var getOwnDataMessage: String?
        var getOwnDataData: UserModel?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                getOwnDataValid = .invalid
                getOwnDataMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                getOwnDataValid = .invalid
                getOwnDataMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                getOwnDataValid = .invalid
                getOwnDataMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                let JSONDecoder = JSONDecoder()
                
                guard let ownData: UserModel = try? JSONDecoder.decode(UserModel.self, from: data ?? Data()) else {
                    getOwnDataValid = .invalid
                    getOwnDataMessage = "Decoding error"
                    return
                }
                
                getOwnDataValid = .valid
                getOwnDataMessage = "Success"
                getOwnDataData = ownData
                return
            }
            
            getOwnDataValid = .invalid
            getOwnDataMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()

        return (getOwnDataValid, getOwnDataMessage, getOwnDataData)
    }
    
    func getPuzzles(firstId: Int?, lastId: Int?, difficulty: Int, number: Int, own: Bool) async -> (valid: APIValid?, message: String?, puzzles: [PuzzleModel]?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/sudoku"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let queryItems = [URLQueryItem(name: "firstId", value: String(firstId ?? 0)), URLQueryItem(name: "lastId", value: String(lastId ?? 0)), URLQueryItem(name: "difficulty", value: String(difficulty)), URLQueryItem(name: "number", value: String(number)), URLQueryItem(name: "own", value: String(own))]
        request.url?.append(queryItems: queryItems)
        
        var getPuzzlesByDifficultyAndPageValid: APIValid?
        var getPuzzlesByDifficultyAndPageMessage: String?
        var getPuzzlesByDifficultyAndPageData: [PuzzleModel]?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                getPuzzlesByDifficultyAndPageValid = .invalid
                getPuzzlesByDifficultyAndPageMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                getPuzzlesByDifficultyAndPageValid = .invalid
                getPuzzlesByDifficultyAndPageMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                getPuzzlesByDifficultyAndPageValid = .invalid
                getPuzzlesByDifficultyAndPageMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                let JSONDecoder = JSONDecoder()
                
                guard let puzzlesByDifficultyAndPageData: [PuzzleModel] = try? JSONDecoder.decode([PuzzleModel].self, from: data ?? Data()) else {
                    getPuzzlesByDifficultyAndPageValid = .invalid
                    getPuzzlesByDifficultyAndPageMessage = "Decoding error"
                    return
                }
                
                getPuzzlesByDifficultyAndPageValid = .valid
                getPuzzlesByDifficultyAndPageMessage = "Success"
                getPuzzlesByDifficultyAndPageData = puzzlesByDifficultyAndPageData
                return
            }
            
            getPuzzlesByDifficultyAndPageValid = .invalid
            getPuzzlesByDifficultyAndPageMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (getPuzzlesByDifficultyAndPageValid, getPuzzlesByDifficultyAndPageMessage, getPuzzlesByDifficultyAndPageData)
    }
    
    func executeGrabber(image: UIImage) async -> (valid: APIValid?, message: String?, string: String?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/sudoku" + "/uploadImage"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        guard let imageData: Data = image.jpegData(compressionQuality: 0.8) else {
            return (.invalid, "Error with getting image png data", nil)
        }

        var imageBase64String: String = imageData.base64EncodedString()
        imageBase64String = "data:image/jpeg;base64," + imageBase64String

        let message: GrabberModel = GrabberModel(
            imageBase64String: imageBase64String
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var executeGrabberValid: APIValid?
        var executeGrabberMessage: String?
        var executeGrabberData: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                executeGrabberValid = .invalid
                executeGrabberMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                executeGrabberValid = .invalid
                executeGrabberMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                executeGrabberValid = .invalid
                executeGrabberMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                executeGrabberValid = .valid
                executeGrabberMessage = "Success"
                executeGrabberData = String(decoding: data ?? Data(), as: UTF8.self)
                return
            }
            
            executeGrabberValid = .invalid
            executeGrabberMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (executeGrabberValid, executeGrabberMessage, executeGrabberData)
    }
    
    func addPuzzle(puzzleString: String) async -> (valid: APIValid?, message: String?, newPuzzle: PuzzleModel?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/sudoku" + "/uploadPuzzle"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let message: AddPuzzleModel = AddPuzzleModel(
            string: puzzleString
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var addPuzzleValid: APIValid?
        var addPuzzleMessage: String?
        var addPuzzleData: PuzzleModel?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                addPuzzleValid = .invalid
                addPuzzleMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                addPuzzleValid = .invalid
                addPuzzleMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                addPuzzleValid = .invalid
                addPuzzleMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                let JSONDecoder = JSONDecoder()
                
                guard let newPuzzle: PuzzleModel = try? JSONDecoder.decode(PuzzleModel.self, from: data ?? Data()) else {
                    addPuzzleValid = .invalid
                    addPuzzleMessage = "Decoding error"
                    return
                }
                
                addPuzzleValid = .valid
                addPuzzleMessage = "Success"
                addPuzzleData = newPuzzle
                return
            }
            
            addPuzzleValid = .invalid
            addPuzzleMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (addPuzzleValid, addPuzzleMessage, addPuzzleData)
    }
    
    func addAttempt(puzzleId: Int, completion: Bool, time: Int) async -> (valid: APIValid?, message: String?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token")
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/attempt"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let message: AddAttemptModel = AddAttemptModel(
            puzzleId: puzzleId,
            completion: completion,
            time: time
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var addAttemptValid: APIValid?
        var addAttemptMessage: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                addAttemptValid = .invalid
                addAttemptMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                addAttemptValid = .invalid
                addAttemptMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                addAttemptValid = .invalid
                addAttemptMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                addAttemptValid = .valid
                addAttemptMessage = "Success"
                return
            }
            
            addAttemptValid = .invalid
            addAttemptMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (addAttemptValid, addAttemptMessage)
    }
    
    func executeHelper(puzzleId: Int, puzzleString: String, userString: String, solutionString: String) async -> (valid: APIValid?, message: String?, steps: [String]?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/sudoku" + "/solveStepByStep"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")

        let message: HelperModel = HelperModel(
            id: puzzleId,
            puzzleString: puzzleString,
            userString: userString,
            solutionString: solutionString
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var executeHelperValid: APIValid?
        var executeHelperMessage: String?
        var executeHelperData: [String]?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                executeHelperValid = .invalid
                executeHelperMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                executeHelperValid = .invalid
                executeHelperMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                executeHelperValid = .invalid
                executeHelperMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                executeHelperValid = .valid
                executeHelperMessage = "Success"
                executeHelperData = String(decoding: data ?? Data(), as: UTF8.self).components(separatedBy: "/")
                return
            }
            
            executeHelperValid = .invalid
            executeHelperMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (executeHelperValid, executeHelperMessage, executeHelperData)
    }
    
    func deleteAccount() async -> (valid: APIValid?, message: String?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token")
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/authorization"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        var deleteAccountValid: APIValid?
        var deleteAccountMessage: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                deleteAccountValid = .invalid
                deleteAccountMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                deleteAccountValid = .invalid
                deleteAccountMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                deleteAccountValid = .invalid
                deleteAccountMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                deleteAccountValid = .valid
                deleteAccountMessage = "Success"
                return
            }
            
            deleteAccountValid = .invalid
            deleteAccountMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (deleteAccountValid, deleteAccountMessage)
    }
    
    func getGlobalStandings(lastPosition: Int) async -> (valid: APIValid?, message: String?, data: [StandingModel]?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/user" + "/globalStanding"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let queryItems = [URLQueryItem(name: "lastPosition", value: String(lastPosition))]
        request.url?.append(queryItems: queryItems)
        
        var getGlobalStandingValid: APIValid?
        var getGlobalStandingMessage: String?
        var getGlobalStandingData: [StandingModel]?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                getGlobalStandingValid = .invalid
                getGlobalStandingMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                getGlobalStandingValid = .invalid
                getGlobalStandingMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                getGlobalStandingValid = .invalid
                getGlobalStandingMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                let JSONDecoder = JSONDecoder()
                
                guard let globalStandingData: [StandingModel] = try? JSONDecoder.decode([StandingModel].self, from: data ?? Data()) else {
                    getGlobalStandingValid = .invalid
                    getGlobalStandingMessage = "Decoding error"
                    return
                }
                
                getGlobalStandingValid = .valid
                getGlobalStandingMessage = "Success"
                getGlobalStandingData = globalStandingData
                return
            }
            
            getGlobalStandingValid = .invalid
            getGlobalStandingMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (getGlobalStandingValid, getGlobalStandingMessage, getGlobalStandingData)
    }
    
    func getNationalityStandings(lastPosition: Int) async -> (valid: APIValid?, message: String?, data: [StandingModel]?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/user" + "/nationalityStanding"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let queryItems = [URLQueryItem(name: "lastPosition", value: String(lastPosition))]
        request.url?.append(queryItems: queryItems)
        
        var getNationalityStandingValid: APIValid?
        var getNationalityStandingMessage: String?
        var getNationalityStandingData: [StandingModel]?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                getNationalityStandingValid = .invalid
                getNationalityStandingMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                getNationalityStandingValid = .invalid
                getNationalityStandingMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                getNationalityStandingValid = .invalid
                getNationalityStandingMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                let JSONDecoder = JSONDecoder()
                
                guard let nationalityStandingData: [StandingModel] = try? JSONDecoder.decode([StandingModel].self, from: data ?? Data()) else {
                    getNationalityStandingValid = .invalid
                    getNationalityStandingMessage = "Decoding error"
                    return
                }
                
                getNationalityStandingValid = .valid
                getNationalityStandingMessage = "Success"
                getNationalityStandingData = nationalityStandingData
                return
            }
            
            getNationalityStandingValid = .invalid
            getNationalityStandingMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (getNationalityStandingValid, getNationalityStandingMessage, getNationalityStandingData)
    }
    
    func getUserData(userId: Int) async -> (valid: APIValid?, message: String?, data: UserModel?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token", nil)
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/user" + "/userData"
        let url: URL = URL(string: fullAPIURL)!
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let queryItems = [URLQueryItem(name: "id", value: String(userId))]
        request.url?.append(queryItems: queryItems)
        
        var getUserDataValid: APIValid?
        var getUserDataMessage: String?
        var getUserDataData: UserModel?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                getUserDataValid = .invalid
                getUserDataMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode

            guard responseCode != 500 else {
                getUserDataValid = .invalid
                getUserDataMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                getUserDataValid = .invalid
                getUserDataMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                let JSONDecoder = JSONDecoder()
                
                guard let userData: UserModel = try? JSONDecoder.decode(UserModel.self, from: data ?? Data()) else {
                    getUserDataValid = .invalid
                    getUserDataMessage = "Decoding error"
                    return
                }
                
                getUserDataValid = .valid
                getUserDataMessage = "Success"
                getUserDataData = userData
                return
            }
            
            getUserDataValid = .invalid
            getUserDataMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()

        return (getUserDataValid, getUserDataMessage, getUserDataData)
    }
    
    func editProfile(firstName: String, lastName: String, username: String, email: String?, nationalityEntered: Bool, nationality: String?, dateOfBirthEntered: Bool, dateOfBirth: Date?) async -> (valid: APIValid?, message: String?) {
        let (getTokenValid, getTokenMessage, getTokenData) = KeychainManager.shared.get(service: "token", account: "user")
        
        guard getTokenValid == .valid else {
            return (.invalid, "Error with getting token")
        }
        
        let tokenString: String = String(decoding: getTokenData!, as: UTF8.self)
        
        let fullAPIURL: String = baseAPIURL + "/user"
        let url: URL = URL(string: fullAPIURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        
        var dateOfBirthString: String = ""
        var nationalityCode: String = ""
        
        if nationalityEntered {
            nationalityCode = (nationality?.uppercased())!
        }
        
        if dateOfBirthEntered {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateOfBirthString = dateFormatter.string(from: dateOfBirth!)
        }
        
        let message: EditUserModel = EditUserModel(
            firstName: firstName,
            lastName: lastName,
            username: username,
            email: email,
            nationality: nationalityCode,
            dateOfBirth: dateOfBirthString
        )
        
        let data = try! JSONEncoder().encode(message)
        
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        var editUserValid: APIValid?
        var editUserMessage: String?
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }
            
            guard response != nil else {
                editUserValid = .invalid
                editUserMessage = "Unknown error"
                return
            }
            
            let responseCode: Int = (response as! HTTPURLResponse).statusCode
            
            guard responseCode != 500 else {
                editUserValid = .invalid
                editUserMessage = "Server error"
                return
            }
            
            guard responseCode != 400 else {
                editUserValid = .invalid
                editUserMessage = "User error"
                return
            }
            
            guard responseCode != 200 else {
                editUserValid = .valid
                editUserMessage = "Success"
                return
            }
            
            editUserValid = .invalid
            editUserMessage = "Unknown error"
        }
        
        task.resume()
        semaphore.wait()
        
        return (editUserValid, editUserMessage)
    }
}
