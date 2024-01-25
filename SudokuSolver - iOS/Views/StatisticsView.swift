//
//  StatisticsView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import UIKit

class StatisticsView: UIView {
    let statisticsViewModel: StatisticsViewModel
    
    private let successSection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Success"
        label.textColor = .white
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let successValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let failureSection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let failureLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Failure"
        label.textColor = .white
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let failureValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    private let recordSection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Record"
        label.textColor = .white
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        
        return label
    }()
    
    private let recordValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        statisticsViewModel = StatisticsViewModel()
        
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
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        
        addSubview(successSection)
        
        successSection.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
            make.height.equalTo(50)
        }
        
        successSection.addSubview(successLabel)
        
        successLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        successSection.addSubview(successValueLabel)
        
        successValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(successLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        addSubview(failureSection)
        
        failureSection.snp.makeConstraints { make -> Void in
            make.top.equalTo(successSection)
            make.leading.equalTo(successSection.snp.trailing).offset(10)
            make.width.equalTo(successSection)
            make.height.equalTo(successSection)
        }
        
        failureSection.addSubview(failureLabel)
        
        failureLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(successLabel)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(successLabel)
        }
        
        failureSection.addSubview(failureValueLabel)
        
        failureValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(failureLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(successValueLabel)
        }
        
        addSubview(recordSection)
        
        recordSection.snp.makeConstraints { make -> Void in
            make.top.equalTo(failureSection)
            make.leading.equalTo(failureSection.snp.trailing).offset(10)
            make.width.equalTo(failureSection)
            make.height.equalTo(failureSection)
        }
        
        recordSection.addSubview(recordLabel)
        
        recordLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(failureLabel)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(failureLabel)
        }
        
        recordSection.addSubview(recordValueLabel)
        
        recordValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(recordLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(failureValueLabel)
        }
    }
    
    func setupUIFunctionality() {
        statisticsViewModel.statisticsViewModelDelegate = self
    }
    
    func updateData(successAttempts: Int, failureAttempts: Int, numberOfRecords: Int) {
        statisticsViewModel.updateData(successAttempts: successAttempts, failureAttempts: failureAttempts, numberOfRecords: numberOfRecords)
    }
}

extension StatisticsView: StatisticsViewModelDelegate {
    func updateStatisticsData() {
        successValueLabel.text = statisticsViewModel.successAttempts.toString()
        failureValueLabel.text = statisticsViewModel.failureAttempts.toString()
        recordValueLabel.text = statisticsViewModel.numberOfRecords.toString()
    }
}
