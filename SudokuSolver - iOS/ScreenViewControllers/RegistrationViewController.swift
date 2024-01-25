//
//  RegistrationViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 11.12.2023..
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {    
    let registrationViewModel: RegistrationViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let registrationFormView: ProfileFormView = ProfileFormView(showPassword: true)
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init() {
        registrationViewModel = RegistrationViewModel()
        
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
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Registration"
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
            make.height.equalTo(565)
        }
        
        contentView.addSubview(registrationFormView)
        
        registrationFormView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(490)
        }
        
        contentView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(registrationFormView.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    func setupUIFunctionality() {
        registrationViewModel.registrationViewModelDelegate = self
        registrationFormView.profileFormViewModel.profileFormViewModelParentDelegate = registrationViewModel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(loginButtonPress))
        confirmButton.addTarget(self, action: #selector(registrationButtonPress(sender:)), for: .touchUpInside)
    }
}

extension RegistrationViewController {
    @objc func loginButtonPress() {
        registrationViewModel.navigateToLogin()
    }
    
    @objc func registrationButtonPress(sender: UIButton) {
        sender.onButtonPressAnimation()
        showLoadingModal()
        registrationFormView.resetTextFieldCursor()
        registrationViewModel.registration()
    }
}

extension RegistrationViewController: RegistrationViewModelDelegate {
    func updateNationalityData(name: String, code: String, row: Int) {
        registrationFormView.profileFormViewModel.updateNationalityTextFieldText(name: name)
        registrationFormView.profileFormViewModel.updateNationalityCode(code: code)
        registrationFormView.profileFormViewModel.updateNationalityRow(row: row)
    }
    
    func getRegistrationFormData() -> RegistrationFormModel {
        return registrationFormView.getRegistrationFormData()
    }
    
    func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToProfile() {
        let profileViewController: ProfileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func showNationalityPickerModal(nationalityRow: Int) {
        let nationalityPickerViewController: NationalityPickerViewController = NationalityPickerViewController(startRow: nationalityRow)
        nationalityPickerViewController.nationalityPickerViewModel.nationalityPickerViewModelParentDelegate = registrationViewModel
        present(nationalityPickerViewController, animated: true)
    }
    
    func showRegistrationFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with registration", message: "Try again", preferredStyle: .alert)
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
        dismiss(animated: true, completion: completion)
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
