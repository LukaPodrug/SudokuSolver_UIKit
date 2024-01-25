//
//  ProfileViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 13.12.2023..
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    let profileViewModel: ProfileViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = UIView()
    
    private let dataSection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let userDataView: UserDataView = UserDataView()
    
    private let dataButtonsView: DataButtonsView = DataButtonsView()
    
    private let statisticsView: StatisticsView = StatisticsView()
    
    private let inputButtonsView: InputButtonsView = InputButtonsView()
    
    private let puzzlesSection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let difficultySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Beginner", "Easy", "Medium", "Hard", "Evil"])
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    private let loadNewPuzzlesButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Load newer puzzles", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let puzzlesListCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        
        return collectionViewFlowLayout
    }()
    
    private let puzzlesListCollectionViewController: PuzzlesListCollectionViewController = PuzzlesListCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    init() {
        profileViewModel = ProfileViewModel()
        
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
            await profileViewModel.setup()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonPress))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPress))
        navigationItem.hidesBackButton = true
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make -> Void in
            make.top.leading.width.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(dataSection)
        
        dataSection.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        dataSection.addSubview(userDataView)
        
        userDataView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        dataSection.addSubview(dataButtonsView)
        
        dataButtonsView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        contentView.addSubview(statisticsView)
        
        statisticsView.snp.makeConstraints { make -> Void in
            make.top.equalTo(userDataView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
        
        contentView.addSubview(inputButtonsView)
        
        inputButtonsView.snp.makeConstraints { make -> Void in
            make.top.equalTo(statisticsView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(65)
        }
        
        contentView.addSubview(puzzlesSection)
        
        puzzlesSection.snp.makeConstraints { make -> Void in
            make.top.equalTo(inputButtonsView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        puzzlesSection.addSubview(difficultySegmentedControl)
        
        difficultySegmentedControl.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().offset(-10)
        }
        
        puzzlesSection.addSubview(loadNewPuzzlesButton)
        
        loadNewPuzzlesButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(difficultySegmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(difficultySegmentedControl)
            make.width.equalTo(difficultySegmentedControl)
            make.height.equalTo(45)
        }
        
        puzzlesSection.addSubview(puzzlesListCollectionViewController.view)
        
        puzzlesListCollectionViewController.collectionView.setCollectionViewLayout(puzzlesListCollectionViewFlowLayout, animated: false)
        
        puzzlesListCollectionViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(loadNewPuzzlesButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalTo(loadNewPuzzlesButton)
            make.width.equalTo(loadNewPuzzlesButton)
            make.height.equalTo(1290)
        }
    }
    
    func setupUIFunctionality() {
        profileViewModel.profileViewModelDelegate = self
        setupScrollViewFunctionality()
        setupOwnDataButtonsViewFunctionality()
        setupInputSectionFunctionality()
        setupPuzzlesSectionFunctionality()
    }
    
    func setupScrollViewFunctionality() {
        scrollView.delegate = self
    }
    
    func setupOwnDataButtonsViewFunctionality() {
        dataButtonsView.dataButtonsViewModel.dataButtonsViewModelParentDelegate = profileViewModel
    }
    
    func setupInputSectionFunctionality() {
        inputButtonsView.inputViewModel.inputViewModelParentDelegate = profileViewModel
    }
    
    func setupPuzzlesSectionFunctionality() {
        difficultySegmentedControl.addTarget(self, action: #selector(updateDifficulty), for: .valueChanged)
        loadNewPuzzlesButton.addTarget(self, action: #selector(getNewPuzzlesButtonPress(sender:)), for: .touchUpInside)
        puzzlesListCollectionViewController.puzzlesListCollectionViewDelegate = profileViewModel
    }
}

extension ProfileViewController {
    @objc func deleteButtonPress() {
        profileViewModel.deleteAccount()
    }
    
    @objc func logoutButtonPress() {
        profileViewModel.logout()
    }
    
    @objc func getNewPuzzlesButtonPress(sender: UIButton) {
        sender.onButtonPressAnimation()
        profileViewModel.getNewPuzzles()
    }
    
    @objc func updateDifficulty() {
        profileViewModel.puzzlesDifficultyIndex = difficultySegmentedControl.selectedSegmentIndex
        updatePuzzlesList()
        profileViewModel.calculatePuzzlesListCollectionViewHeight(difficulty: profileViewModel.puzzlesDifficultyIndex + 1)
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func removeLoggedOutViewControllers() {
        if navigationController?.viewControllers.count == 2 {
            navigationController?.viewControllers.remove(at: 0)
        }
        
        else if navigationController?.viewControllers.count == 3 {
            navigationController?.viewControllers.remove(at: 0)
            navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    func updateOwnData() {
        userDataView.updateData(userData: profileViewModel.ownData)
        statisticsView.updateData(successAttempts: profileViewModel.ownData.successAttempts - profileViewModel.ownData.numberOfRecords, failureAttempts: profileViewModel.ownData.failureAttempts, numberOfRecords: profileViewModel.ownData.numberOfRecords)
        puzzlesListCollectionViewController.updateOwnData(ownData: profileViewModel.ownData)
    }
    
    func updatePuzzlesList() {
        puzzlesListCollectionViewController.updatePuzzles(puzzles: profileViewModel.puzzles[profileViewModel.puzzlesDifficultyIndex])
        puzzlesListCollectionViewController.updateData()

        if navigationController?.presentedViewController is LoadingViewController {
            hideNavigationControllerModal()
        }
    }
    
    func navigateToLogin() {
        let loginViewController: LoginViewController = LoginViewController(afterLogout: true)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func showDeleteAccountQueryAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Delete account", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in self.profileViewModel.handleDeleteAccountConfirmation() }))
        present(alertController, animated: true)
    }
    
    func showDeleteAccountConfirmationFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with deleting account", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showRemoveTokenFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with removing token", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showGetOwnDataFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting own data", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showGetPuzzlesFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting puzzles", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showMyPuzzlesModal() {
        let myPuzzlesViewController: MyPuzzlesViewController = MyPuzzlesViewController()
        myPuzzlesViewController.myPuzzlesViewModel.myPuzzlesViewModelParentDelegate = profileViewModel
        present(myPuzzlesViewController, animated: true)
    }
    
    func showStandingsModal() {
        let standingsViewController: StandingsViewController = StandingsViewController(ownData: profileViewModel.ownData)
        present(standingsViewController, animated: true)
    }
    
    func showEditProfileModal() {
        let editProfileViewController: EditProfileViewController = EditProfileViewController(ownData: profileViewModel.ownData)
        editProfileViewController.isModalInPresentation = true
        editProfileViewController.editProfileViewModel.editProfileViewModelParentDelegate = profileViewModel
        present(editProfileViewController, animated: true)
    }
    
    func showPlayPuzzleModal(puzzleData: PuzzleModel) {
        let puzzleViewController: PuzzleViewController = PuzzleViewController(inputMode: false, playMode: true, puzzleData: puzzleData, puzzleGrabberString: nil)
        puzzleViewController.puzzleViewModel.puzzleViewModelParentDelegate = profileViewModel
        puzzleViewController.isModalInPresentation = true
        present(puzzleViewController, animated: true)
    }
    
    func showUserModal(userId: Int) {
        let userViewController: UserViewController = UserViewController(userId: userId)
        present(userViewController, animated: true)
    }
    
    func showManualInputModal() {
        let puzzleViewController: PuzzleViewController = PuzzleViewController(inputMode: true, playMode: false, puzzleData: nil, puzzleGrabberString: nil)
        puzzleViewController.puzzleViewModel.puzzleViewModelParentDelegate = profileViewModel
        puzzleViewController.isModalInPresentation = true
        present(puzzleViewController, animated: true)
    }
    
    func showGalleryInputModal() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        
        else {
            showGalleryInputDeniedAccessAlert()
        }
    }
    
    func showGalleryInputDeniedAccessAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Gallery access denied", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showCameraInputModal() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
        
        else {
            showCameraInputDeniedAccessAlert()
        }
    }
    
    func showCameraInputDeniedAccessAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Camera access denied", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showImageInputModal(puzzleGrabberString: String) {
        let puzzleViewController: PuzzleViewController = PuzzleViewController(inputMode: true, playMode: false, puzzleData: nil, puzzleGrabberString: puzzleGrabberString)
        puzzleViewController.puzzleViewModel.puzzleViewModelParentDelegate = profileViewModel
        puzzleViewController.isModalInPresentation = true
        present(puzzleViewController, animated: true)
    }
    
    func hideImageInputModal() {
        hideModal(completion: nil)
    }
    
    func showExecuteGrabberFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with executing grabber", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        present(loadingViewController, animated: true)
    }
    
    func hideModal(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
    func hideNavigationControllerModal() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func updatePuzzlesListCollectionViewHeight(height: Float) {
        puzzlesListCollectionViewController.view.snp.updateConstraints { make -> Void in
            make.height.equalTo(height)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hideImageInputModal()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileViewModel.inputImagePicked(image: (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!)
        hideImageInputModal()
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 && scrollView.contentOffset.y + 1 >= scrollView.contentSize.height - scrollView.frame.size.height {
            profileViewModel.getMorePuzzles()
        }
    }
}
