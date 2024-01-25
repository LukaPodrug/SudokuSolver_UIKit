//
//  LoginFormView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import UIKit

class LoginFormView: UIView {
    let loginFormViewModel: LoginFormViewModel
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Username"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let usernameTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Password"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.isSecureTextEntry = true
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    init() {
        loginFormViewModel = LoginFormViewModel()
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setupUI()
        setupUIFunctionality()
        
        super.draw(rect)
    }
    
    func setupUI() {
        addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        addSubview(usernameTextField)
        
        usernameTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        addSubview(passwordLabel)
        
        passwordLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.width.equalTo(usernameLabel)
            make.height.equalTo(usernameLabel)
        }
        
        addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(usernameTextField)
        }
    }
    
    func setupUIFunctionality() {
        loginFormViewModel.loginFormViewModelDelegate = self
        setupKeyboardFunctionality()
        setupUsernameTextFieldFunctionality()
        setupPasswordTextFieldFunctionality()
    }
    
    func setupKeyboardFunctionality() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUsernameTextFieldFunctionality() {
        usernameTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        usernameTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
    
    func setupPasswordTextFieldFunctionality() {
        passwordTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
}

extension LoginFormView {
    @objc func hideKeyboard() {
        endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        loginFormViewModel.keyboardWillShow(notification: sender)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        loginFormViewModel.keyboardWillHide()
    }
    
    @objc func textFieldFocus(sender: CustomTextField) {
        sender.updateBackgroundColor(backgroundColor: .systemGray4)
    }
    
    @objc func textFieldUnfocus(sender: CustomTextField) {
        sender.updateBackgroundColor(backgroundColor: .systemGray5)
    }
}

extension LoginFormView: LoginFormViewModelDelegate {
    func getFormData() -> LoginFormModel {
        return LoginFormModel(username: usernameTextField.text!, passwordPlaintext: passwordTextField.text!)
    }
    
    func resetTextFieldValues() {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func resetTextFieldCursor() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
