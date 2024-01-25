//
//  StandingsViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 04.01.2024..
//

import UIKit

class StandingsViewController: UIViewController {
    let standingsViewModel: StandingsViewModel
    
    private let standingTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Standings"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let regionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Gloabal", "Nationality"])
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    private let standingsTableViewController: StandingsTableViewController = StandingsTableViewController()
    
    init(ownData: UserModel) {
        standingsViewModel = StandingsViewModel(ownData: ownData)
        
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
            await standingsViewModel.setup()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(standingTitleLabel)
        
        standingTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(regionSegmentedControl)
        
        regionSegmentedControl.snp.makeConstraints { make -> Void in
            make.top.equalTo(standingTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
        
        view.addSubview(standingsTableViewController.view)
        
        standingsTableViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(regionSegmentedControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(regionSegmentedControl.snp.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupUIFunctionality() {
        standingsViewModel.standingsViewModelDelegate = self
        
        regionSegmentedControl.addTarget(self, action: #selector(updateRegion), for: .valueChanged)
        
        if standingsViewModel.ownData.nationality == nil {
            regionSegmentedControl.setEnabled(false, forSegmentAt: 1)
        }
        
        standingsTableViewController.standingsTableViewDelegate = standingsViewModel
    }
}

extension StandingsViewController {
    @objc func updateRegion() {
        standingsViewModel.regionIndex = regionSegmentedControl.selectedSegmentIndex
        updateStandings()
    }
}

extension StandingsViewController: StandingsViewModelDelegate {
    func updateStandings() {
        standingsTableViewController.updateStandings(standings: standingsViewModel.standings[standingsViewModel.regionIndex])
        standingsTableViewController.updateStandingsLoadMore(standigsLoadMore: standingsViewModel.standingsLoadMore[standingsViewModel.regionIndex])
        standingsTableViewController.updateData()
        
        if presentedViewController is LoadingViewController {
            hideModal(completion: nil)
        }
    }
    
    func showGetGlobalStandingsFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting global standings", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showGetNationalityStandingsFailureAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Error with getting nationality standings", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.hideModal(completion: nil) }))
        present(alertController, animated: true)
    }
    
    func showUserModal(userId: Int) {
        let userViewController: UserViewController = UserViewController(userId: userId)
        present(userViewController, animated: true)
    }
    
    func showLoadingModal() {
        let loadingViewController: LoadingViewController = LoadingViewController()
        present(loadingViewController, animated: true)
    }
    
    func hideModal(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
}
