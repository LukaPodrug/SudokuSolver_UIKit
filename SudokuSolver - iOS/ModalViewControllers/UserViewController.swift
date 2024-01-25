//
//  UserViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 04.01.2024..
//

import UIKit
import SwiftUI

class UserViewController: UIViewController {
    let userViewModel: UserViewModel
    
    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Profile"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()

    private let userDataView: UserDataView = UserDataView()
    
    private let statisticsView: StatisticsView = StatisticsView()
    
    init(userId: Int) {
        userViewModel = UserViewModel(userId: userId)
        
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
            await userViewModel.setup()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileTitleLabel)
        
        profileTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(userDataView)
        
        userDataView.snp.makeConstraints { make -> Void in
            make.top.equalTo(profileTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(userDataView.snp.width)
        }
        
        view.addSubview(statisticsView)
        
        statisticsView.snp.makeConstraints { make -> Void in
            make.top.equalTo(userDataView.snp.bottom).offset(10)
            make.leading.equalTo(userDataView)
            make.width.equalTo(userDataView)
            make.height.equalTo(70)
        }
    }
    
    func setupUIFunctionality() {
        userViewModel.userViewModelDelegate = self
    }
}

extension UserViewController: UserViewModelDelegate {
    func updateUserData() {
        userDataView.updateData(userData: userViewModel.userData)
        statisticsView.updateData(successAttempts: userViewModel.userData.successAttempts - userViewModel.userData.numberOfRecords, failureAttempts: userViewModel.userData.failureAttempts, numberOfRecords: userViewModel.userData.numberOfRecords)
        hideModal(completion: nil)
    }
    
    func showGetUserDataFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting user data", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        present(loadingViewController, animated: true)
    }
    
    func hideModal(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
}
