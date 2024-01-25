//
//  UserDataView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import UIKit
import SwiftUI

class UserDataView: UIView {
    let userDataViewModel: UserDataViewModel
    
    private let donutChartHostingController: UIHostingController = {
        let hostingController = UIHostingController(rootView: DonutChart(statistics: [StatisticModel(title: "Default", value: 1, color: .gray)]))
        
        hostingController.view.backgroundColor = .clear
        
        return hostingController
    }()
    
    private let userDataValueView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Name"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let nameValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Username"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let usernameValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let emailValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let nationalityLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Nationality"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let nationalityValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Date of birth"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let dateOfBirthValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let nationalStandingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "# National"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let nationalStandingValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let globalStandingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "# Global"
        label.textColor = .black
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let globalStandingValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        userDataViewModel = UserDataViewModel()
        
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
        backgroundColor = .clear
        
        addSubview(donutChartHostingController.view)
        
        donutChartHostingController.view.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().offset(-10)
            make.height.equalTo(donutChartHostingController.view.snp.width).offset(-20)
        }
        
        addSubview(userDataValueView)
        
        userDataValueView.layer.cornerRadius = ((frame.width - 5) * 0.65 - 20) / 2
        
        userDataValueView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(donutChartHostingController.view)
            make.centerX.equalTo(donutChartHostingController.view)
            make.width.equalTo(donutChartHostingController.view.snp.width).multipliedBy(0.65).offset(-10)
            make.height.equalTo(userDataValueView.snp.width)
        }
        
        userDataValueView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(15)
        }
        
        userDataValueView.addSubview(nameValueLabel)
        
        nameValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        userDataValueView.addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(10)
            make.centerX.equalTo(nameValueLabel)
            make.width.equalTo(nameValueLabel)
            make.height.equalTo(nameLabel)
        }
        
        userDataValueView.addSubview(usernameValueLabel)
        
        usernameValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.centerX.equalTo(usernameLabel)
            make.width.equalTo(nameLabel)
            make.height.equalTo(nameValueLabel)
        }
        
        userDataValueView.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(usernameValueLabel.snp.bottom).offset(10)
            make.centerX.equalTo(usernameValueLabel)
            make.width.equalTo(usernameLabel)
            make.height.equalTo(usernameLabel)
        }
        
        userDataValueView.addSubview(emailValueLabel)
        
        emailValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(emailLabel.snp.bottom)
            make.centerX.equalTo(emailLabel)
            make.width.equalTo(emailLabel)
            make.height.equalTo(usernameValueLabel)
        }
        
        userDataValueView.addSubview(nationalityLabel)
        
        nationalityLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(emailValueLabel.snp.bottom).offset(10)
            make.trailing.equalTo(userDataValueView.snp.centerX).offset(-5)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(emailLabel)
        }
        
        userDataValueView.addSubview(nationalityValueLabel)
        
        nationalityValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalityLabel.snp.bottom)
            make.trailing.equalTo(nationalityLabel)
            make.width.equalTo(nationalityLabel)
            make.height.equalTo(emailValueLabel)
        }
        
        userDataValueView.addSubview(dateOfBirthLabel)
        
        dateOfBirthLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalityLabel)
            make.leading.equalTo(userDataValueView.snp.centerX).offset(5)
            make.width.equalTo(nationalityLabel)
            make.height.equalTo(nationalityLabel)
        }
        
        userDataValueView.addSubview(dateOfBirthValueLabel)
        
        dateOfBirthValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalityValueLabel)
            make.leading.equalTo(dateOfBirthLabel)
            make.width.equalTo(dateOfBirthLabel)
            make.height.equalTo(nationalityValueLabel)
        }
        
        userDataValueView.addSubview(nationalStandingLabel)
        
        nationalStandingLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalityValueLabel.snp.bottom).offset(5)
            make.trailing.equalTo(nationalityValueLabel)
            make.width.equalTo(nationalityValueLabel)
            make.height.equalTo(nationalityLabel)
        }
        
        userDataValueView.addSubview(nationalStandingValueLabel)
        
        nationalStandingValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalStandingLabel.snp.bottom)
            make.trailing.equalTo(nationalStandingLabel)
            make.width.equalTo(nationalStandingLabel)
            make.height.equalTo(nationalStandingValueLabel)
        }
        
        userDataValueView.addSubview(globalStandingLabel)
        
        globalStandingLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalStandingLabel)
            make.leading.equalTo(dateOfBirthValueLabel)
            make.width.equalTo(dateOfBirthValueLabel)
            make.height.equalTo(nationalStandingLabel)
        }
        
        userDataValueView.addSubview(globalStandingValueLabel)
        
        globalStandingValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(nationalStandingValueLabel)
            make.leading.equalTo(globalStandingLabel)
            make.width.equalTo(globalStandingLabel)
            make.height.equalTo(nationalStandingValueLabel)
        }
    }
    
    func setupUIFunctionality() {
        userDataViewModel.userDataViewModelDelegate = self
    }
    
    func updateData(userData: UserModel) {
        userDataViewModel.updateData(userData: userData)
    }
}

extension UserDataView: UserDataViewModelDelegate {    
    func updateUserData() {
        donutChartHostingController.rootView = DonutChart(statistics: [StatisticModel(title: "Success", value: userDataViewModel.userData.successAttempts - userDataViewModel.userData.numberOfRecords, color: .green), StatisticModel(title: "Failure", value: userDataViewModel.userData.failureAttempts, color: .red), StatisticModel(title: "Record", value: userDataViewModel.userData.numberOfRecords, color: .blue), StatisticModel(title: "Default", value: userDataViewModel.userData.successAttempts + userDataViewModel.userData.failureAttempts == 0 ? 1 : 0, color: .gray)])
        nameValueLabel.text = userDataViewModel.userData.firstName + " " + userDataViewModel.userData.lastName
        usernameValueLabel.text = userDataViewModel.userData.username
        emailValueLabel.text = userDataViewModel.userData.email ?? "-"
        nationalityValueLabel.text = userDataViewModel.userData.nationality ?? "-"
        dateOfBirthValueLabel.text = userDataViewModel.userData.dateOfBirth.toDateString()
        nationalStandingValueLabel.text = userDataViewModel.userData.nationalityStanding.toString()
        globalStandingValueLabel.text = userDataViewModel.userData.globalStanding.toString()
    }
}
