//
//  LoginViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 11.01.2024..
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func removeLoggedInViewControllers()
    func getLoginFormData() -> LoginFormModel
    func navigateToRegistration()
    func navigateToProfile()
    func showVerifyTokenFailureAlert()
    func showRemoveTokenFailureAlert()
    func showLoginFailureAlert()
    func showSaveTokenFailureAlert()
    func showLoadingModal()
    func hideModal(completion: (() -> Void)?)
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
}

class LoginViewModel: ObservableObject {
    var afterLogout: Bool
    var loginFormData: LoginFormModel
    
    weak var loginViewModelDelegate: LoginViewModelDelegate?
    
    init(afterLogout: Bool) {
        self.afterLogout = afterLogout
        self.loginFormData = LoginFormModel(username: "", passwordPlaintext: "")
    }
    
    func setup() async {
        DispatchQueue.main.async {
            if self.afterLogout == true {
                self.loginViewModelDelegate?.removeLoggedInViewControllers()
            }
            
            else {
                self.loginViewModelDelegate?.showLoadingModal()
                
                Task {
                    await self.verifyToken()
                }
            }
        }
    }
    
    func navigateToRegistration() {
        loginViewModelDelegate?.navigateToRegistration()
    }
    
    func verifyToken() async {
        DispatchQueue.main.async {
            Task {
                let (verifyTokenValid, verifyTokenMessage) = await APIManager.shared.verifyToken()
                
                switch verifyTokenValid {
                    case .valid:
                        self.handleVerifyTokenSuccess()
                        break
                    case .missing:
                        self.handleVerifyTokenMissing()
                        break
                    case .invalid:
                        self.removeToken()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleVerifyTokenSuccess() {
        loginViewModelDelegate?.navigateToProfile()
    }
    
    func handleVerifyTokenMissing() {
        loginViewModelDelegate?.hideModal(completion: nil)
    }
    
    func handleVerifyTokenFailure() {
        loginViewModelDelegate?.hideModal(completion: loginViewModelDelegate?.showVerifyTokenFailureAlert)
    }
    
    func removeToken() {
        DispatchQueue.main.async {
            let (removeTokenVaild, removeTokenMessage) = KeychainManager.shared.remove(service: "token", account: "user")
            
            switch removeTokenVaild {
            case .valid:
                self.handleRemoveTokenSuccess()
                break
            case .invalid:
                self.handleRemoveTokenFailure()
                break
            default:
                break
            }
        }
    }
    
    func handleRemoveTokenSuccess() {
        loginViewModelDelegate?.hideModal(completion: nil)
    }
    
    func handleRemoveTokenFailure() {
        loginViewModelDelegate?.hideModal(completion: loginViewModelDelegate?.showRemoveTokenFailureAlert)
    }
    
    func login() {
        DispatchQueue.main.async {
            self.loginFormData = (self.loginViewModelDelegate?.getLoginFormData())!
            
            Task {
                let (loginValid, loginMessage, loginData) = await APIManager.shared.login(username: self.loginFormData.username, passwordPlaintext: self.loginFormData.passwordPlaintext)
                
                switch loginValid {
                    case .valid:
                        self.handleLoginSuccess(token: loginData!)
                        break
                    case .invalid:
                        self.handleLoginFailure()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func handleLoginSuccess(token: String) {
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
    
    func handleLoginFailure() {
        loginViewModelDelegate?.hideModal(completion: loginViewModelDelegate?.showLoginFailureAlert)
    }
    
    func handleSaveTokenSuccess() {
        loginViewModelDelegate?.navigateToProfile()
    }
    
    func handleSaveTokenFailure() {
        loginViewModelDelegate?.showSaveTokenFailureAlert()
    }
}

extension LoginViewModel: LoginFormViewModelParentDelegate {
    func keyboardWillShow(notification: NSNotification) {
        loginViewModelDelegate?.keyboardWillShow(notification: notification)
    }
    
    func keyboardWillHide() {
        loginViewModelDelegate?.keyboardWillHide()
    }
}
