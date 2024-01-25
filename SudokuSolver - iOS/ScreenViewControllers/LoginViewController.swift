//
//  LoginViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 11.12.2023..
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    let loginViewModel: LoginViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let loginFormView: LoginFormView = LoginFormView()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init(afterLogout: Bool) {
        loginViewModel = LoginViewModel(afterLogout: afterLogout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            await loginViewModel.setup()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Login"
        navigationItem.hidesBackButton = true
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make -> Void in
            make.top.leading.width.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(225)
        }
        
        contentView.addSubview(loginFormView)
        
        loginFormView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
        
        contentView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginFormView.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    func setupUIFunctionality() {
        loginViewModel.loginViewModelDelegate = self
        loginFormView.loginFormViewModel.loginFormViewModelParentDelegate = loginViewModel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Registration", style: .plain, target: self, action: #selector(registrationButtonPress))
        confirmButton.addTarget(self, action: #selector(loginButtonPress(sender:)), for: .touchUpInside)
    }
}

extension LoginViewController {
    @objc func registrationButtonPress() {
        loginFormView.resetTextFieldValues()
        loginFormView.resetTextFieldCursor()
        loginViewModel.navigateToRegistration()
    }
    
    @objc func loginButtonPress(sender: UIButton) {
        sender.onButtonPressAnimation()
        showLoadingModal()
        loginFormView.resetTextFieldCursor()
        loginViewModel.login()
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func removeLoggedInViewControllers() {
        DispatchQueue.main.async {
            if self.navigationController?.viewControllers.count == 2 {
                self.navigationController?.viewControllers.remove(at: 0)
                return
            }
        }
    }
    
    func getLoginFormData() -> LoginFormModel {
        return loginFormView.getFormData()
    }
    
    func navigateToRegistration() {
        let registrationViewController: RegistrationViewController = RegistrationViewController()
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    func navigateToProfile() {
        let profileViewController: ProfileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func showVerifyTokenFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with verifying token", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showRemoveTokenFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with removing token", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showLoginFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with login", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showSaveTokenFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with saving token", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        navigationController?.present(loadingViewController, animated: true)
    }
    
    func hideModal(completion: (() -> Void)?) {
        navigationController?.dismiss(animated: true, completion: completion)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        scrollView.snp.updateConstraints { make -> Void in
            make.height.equalTo(view.safeAreaLayoutGuide).offset(view.safeAreaInsets.bottom - notification.getKeyboardHeight())
        }
    }
    
    func keyboardWillHide() {
        scrollView.snp.updateConstraints { make -> Void in
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
