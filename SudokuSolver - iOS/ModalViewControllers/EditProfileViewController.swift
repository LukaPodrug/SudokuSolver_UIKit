//
//  EditProfileViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 06.01.2024..
//

import UIKit

class EditProfileViewController: UIViewController {
    let editProfileViewModel: EditProfileViewModel
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Edit profile"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
    
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let editProfileFormView: ProfileFormView = ProfileFormView(showPassword: false)
    
    init(ownData: UserModel) {
        editProfileViewModel = EditProfileViewModel(ownData: ownData)
        
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
        
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(backButton.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(backButton.snp.height)
        }
        
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(titleLabel.snp.height)
        }
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make -> Void in
            make.top.equalTo(titleLabel).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make -> Void in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).offset(10)
            make.width.equalTo(scrollView).offset(-20)
            make.height.equalTo(490)
        }
        
        contentView.addSubview(editProfileFormView)
        
        editProfileFormView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setupUIFunctionality() {
        editProfileViewModel.editProfileViewModelDelegate = self
        editProfileViewModel.setup()
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(editProfileButtonPress), for: .touchUpInside)
        
        editProfileFormView.profileFormViewModel.profileFormViewModelParentDelegate = editProfileViewModel
    }
}

extension EditProfileViewController {
    @objc func back() {
        hideModal(completion: nil)
    }
    
    @objc func editProfileButtonPress() {
        showLoadingModal()
        editProfileFormView.resetTextFieldCursor()
        editProfileViewModel.editProfile()
    }
}

extension EditProfileViewController: NationalityPickerViewModelParentDelegate {
    func selectNationality(name: String, code: String, row: Int) {
        if name == "None" {
            editProfileFormView.profileFormViewModel.updateNationalityTextFieldText(name: "")
        }
        
        else {
            editProfileFormView.profileFormViewModel.updateNationalityTextFieldText(name: name)
        }
        
        editProfileFormView.profileFormViewModel.updateNationalityCode(code: code)
        editProfileFormView.profileFormViewModel.updateNationalityRow(row: row)
    }
    
    func hideNationalityPickerModal() {
        hideModal(completion: nil)
    }
}

extension EditProfileViewController: EditProfileViewModelDelegate {
    func updateOwnData(ownData: UserModel) {
        editProfileFormView.updateOwnData(ownData: ownData)
    }
    
    func updateNationalityData(name: String, code: String, row: Int) {
        editProfileFormView.profileFormViewModel.updateNationalityTextFieldText(name: name)
        editProfileFormView.profileFormViewModel.updateNationalityCode(code: code)
        editProfileFormView.profileFormViewModel.updateNationalityRow(row: row)
    }
    
    func getEditProfileFormData() -> EditProfileFormModel {
        return editProfileFormView.getEditProfileFormData()
    }
    
    func showNationalityPickerModal(nationalityRow: Int) {
        let nationalityPickerViewController: NationalityPickerViewController = NationalityPickerViewController(startRow: nationalityRow)
        nationalityPickerViewController.nationalityPickerViewModel.nationalityPickerViewModelParentDelegate = editProfileViewModel
        present(nationalityPickerViewController, animated: true)
    }
    
    func showEditProfileSuccessAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Profile successfully updated", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.back() }))
        present(alertController, animated: true)
    }
    
    func showEditProfileFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with editing profile", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        loadingViewController.isModalInPresentation = true
        present(loadingViewController, animated: true)
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
