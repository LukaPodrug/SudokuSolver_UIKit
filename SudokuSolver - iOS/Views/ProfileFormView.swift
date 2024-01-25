//
//  ProfileFormView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import UIKit

class ProfileFormView: UIView {
    let profileFormViewModel: ProfileFormViewModel
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "First name"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let firstNameTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Last name"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let lastNameTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
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
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email (optional)"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let nationalityLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Nationality (optional)"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let nationalityTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Date of birth (optional)"
        label.textColor = .black
        label.font = label.font.withSize(10)
        
        return label
    }()
    
    private let dateOfBirthTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.borderStyle = .roundedRect
        textField.font = textField.font?.withSize(15)
        textField.layer.zPosition = 2
        textField.backgroundColor = .systemGray5
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let dateOfBirthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        picker.contentHorizontalAlignment = .leading
        picker.contentMode = .scaleToFill
        picker.layer.zPosition = 1
        picker.subviews[0].subviews[0].subviews[0].alpha = 0.1
        
        return picker
    }()
    
    private let dateOfBirthDeleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.layer.zPosition = 3
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init(showPassword: Bool) {
        profileFormViewModel = ProfileFormViewModel(showPassword: showPassword)
        
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
        addSubview(firstNameLabel)
        
        firstNameLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        addSubview(firstNameTextField)
        
        firstNameTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstNameLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        addSubview(lastNameLabel)
        
        lastNameLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.width.equalTo(firstNameLabel)
            make.height.equalTo(firstNameLabel)
        }
        
        addSubview(lastNameTextField)
        
        lastNameTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(lastNameLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(firstNameTextField)
        }
        
        addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.width.equalTo(lastNameLabel)
            make.height.equalTo(lastNameLabel)
        }
        
        addSubview(usernameTextField)
        
        usernameTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(lastNameTextField)
        }
        
        if profileFormViewModel.showPassword == true {
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
            
            addSubview(emailLabel)
            
            emailLabel.snp.makeConstraints { make -> Void in
                make.centerX.equalToSuperview()
                make.top.equalTo(passwordTextField.snp.bottom).offset(20)
                make.width.equalTo(passwordLabel)
                make.height.equalTo(passwordLabel)
            }
            
            addSubview(emailTextField)
            
            emailTextField.snp.makeConstraints { make -> Void in
                make.centerX.equalToSuperview()
                make.top.equalTo(emailLabel.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(passwordTextField)
            }
        }
        
        else {
            addSubview(emailLabel)
            
            emailLabel.snp.makeConstraints { make -> Void in
                make.centerX.equalToSuperview()
                make.top.equalTo(usernameTextField.snp.bottom).offset(20)
                make.width.equalTo(usernameLabel)
                make.height.equalTo(usernameLabel)
            }
            
            addSubview(emailTextField)
            
            emailTextField.snp.makeConstraints { make -> Void in
                make.centerX.equalToSuperview()
                make.top.equalTo(emailLabel.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(usernameTextField)
            }
        }
        
        addSubview(nationalityLabel)
        
        nationalityLabel.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(emailLabel)
        }
        
        addSubview(nationalityTextField)
        
        nationalityTextField.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview()
            make.top.equalTo(nationalityLabel.snp.bottom)
            make.width.equalTo(nationalityLabel)
            make.height.equalTo(emailTextField)
        }
        
        addSubview(dateOfBirthLabel)
        
        dateOfBirthLabel.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview().offset(10)
            make.top.equalTo(nationalityLabel)
            make.width.equalTo(nationalityLabel)
            make.height.equalTo(emailLabel)
        }
        
        addSubview(dateOfBirthTextField)
        
        dateOfBirthTextField.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview()
            make.top.equalTo(dateOfBirthLabel.snp.bottom)
            make.width.equalTo(dateOfBirthLabel)
            make.height.equalTo(emailTextField)
        }
        
        addSubview(dateOfBirthPicker)
        
        dateOfBirthPicker.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview()
            make.top.equalTo(dateOfBirthLabel.snp.bottom)
            make.width.equalTo(dateOfBirthLabel)
            make.height.equalTo(emailTextField)
        }
        
        addSubview(dateOfBirthDeleteButton)
        
        dateOfBirthDeleteButton.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview()
            make.top.equalTo(dateOfBirthLabel.snp.bottom)
            make.width.equalTo(dateOfBirthTextField.snp.height)
            make.height.equalTo(dateOfBirthTextField)
        }
    }
    
    func setupUIFunctionality() {
        profileFormViewModel.profileFormViewModelDelegate = self
        setupKeyboardFunctionality()
        setupFirstNameTextFieldFunctionality()
        setupLastNameTextFieldFunctionality()
        setupUsernameTextFieldFunctionality()
        setupPasswordTextFieldFunctionality()
        setupEmailTextFieldFunctionality()
        setupNationalityTextFieldFunctionality()
        setupDateOfBirthTextFieldFunctionality()
    }
    
    func setupKeyboardFunctionality() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupFirstNameTextFieldFunctionality() {
        firstNameTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        firstNameTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
    
    func setupLastNameTextFieldFunctionality() {
        lastNameTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        lastNameTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
    
    func setupUsernameTextFieldFunctionality() {
        usernameTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        usernameTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
    
    func setupPasswordTextFieldFunctionality() {
        passwordTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
    
    func setupEmailTextFieldFunctionality() {
        emailTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
    }
    
    func setupNationalityTextFieldFunctionality() {
        nationalityTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        nationalityTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
        nationalityTextField.delegate = self
    }
    
    func setupDateOfBirthTextFieldFunctionality() {
        dateOfBirthTextField.addTarget(self, action: #selector(textFieldFocus(sender:)), for: .editingDidBegin)
        dateOfBirthTextField.addTarget(self, action: #selector(textFieldUnfocus(sender:)), for: .editingDidEnd)
        dateOfBirthTextField.delegate = self
        dateOfBirthPicker.addTarget(self, action: #selector(updateDateOfBirth), for: .valueChanged)
        dateOfBirthDeleteButton.addTarget(self, action: #selector(deleteDateOfBirth), for: .touchUpInside)
    }
}

extension ProfileFormView {
    func updateOwnData(ownData: UserModel) {
        firstNameTextField.text = ownData.firstName
        lastNameTextField.text = ownData.lastName
        usernameTextField.text = ownData.username
        emailTextField.text = ownData.email
        
        if ownData.nationality != nil {
            (nationalityTextField.text, profileFormViewModel.nationalityRow) = profileFormViewModel.getCountryNameAndRow(countryCode: (ownData.nationality)!)
            profileFormViewModel.nationalityCode = ownData.nationality!
        }
        
        if ownData.dateOfBirth != nil {
            dateOfBirthTextField.text = ownData.dateOfBirth?.toDateString()
            dateOfBirthPicker.date = ownData.dateOfBirth.toDate()
        }
    }
}

extension ProfileFormView {
    @objc func hideKeyboard() {
        endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        profileFormViewModel.keyboardWillShow(notification: sender)
    }
    
    @objc func keyboardWillHide() {
        profileFormViewModel.keyboardWillHide()
    }
    
    @objc func updateDateOfBirth(datePicker: UIDatePicker) {
        dateOfBirthTextField.text = datePicker.date.toString()
    }
    
    @objc func deleteDateOfBirth() {
        dateOfBirthTextField.text = ""
        dateOfBirthPicker.date = Date()
    }
    
    @objc func textFieldFocus(sender: CustomTextField) {
        sender.updateBackgroundColor(backgroundColor: .systemGray4)
    }
    
    @objc func textFieldUnfocus(sender: CustomTextField) {
        sender.updateBackgroundColor(backgroundColor: .systemGray5)
    }
}

extension ProfileFormView: ProfileFormViewModelDelegate {
    func getRegistrationFormData() -> RegistrationFormModel {
        return RegistrationFormModel(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", username: usernameTextField.text ?? "", passwordPlaintext: passwordTextField.text ?? "", email: emailTextField.text ?? "", nationalityEntered: nationalityTextField.text != "" ? true : false, nationality: profileFormViewModel.nationalityCode, dateOfBirthEntered: dateOfBirthTextField.text != "" ? true : false, dateOfBirth: dateOfBirthPicker.date)
    }
    
    func getEditProfileFormData() -> EditProfileFormModel {
        return EditProfileFormModel(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", username: usernameTextField.text ?? "", email: emailTextField.text ?? "", nationalityEntered: nationalityTextField.text != "" ? true : false, nationality: profileFormViewModel.nationalityCode, dateOfBirthEntered: dateOfBirthTextField.text != "" ? true : false, dateOfBirth: dateOfBirthPicker.date)
    }
    
    func updateNationalityTextFieldText(name: String) {
        nationalityTextField.text = name
    }
    
    func resetTextFieldValues() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        nationalityTextField.text = ""
    }
    
    func resetTextFieldCursor() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        nationalityTextField.resignFirstResponder()
        dateOfBirthTextField.resignFirstResponder()
        dateOfBirthPicker.resignFirstResponder()
    }
}

extension ProfileFormView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nationalityTextField {
            profileFormViewModel.profileFormViewModelParentDelegate?.showNationalityPickerModal(nationalityRow: profileFormViewModel.nationalityRow)
        }
        
        return false
    }
}
