//
//  StatisticsViewModel.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 15.01.2024..
//

import Foundation

protocol StatisticsViewModelDelegate: AnyObject {
    func updateStatisticsData()
}

class StatisticsViewModel {
    var successAttempts: Int
    var failureAttempts: Int
    var numberOfRecords: Int
    
    weak var statisticsViewModelDelegate: StatisticsViewModelDelegate?
    
    init() {
        self.successAttempts = 0
        self.failureAttempts = 0
        self.numberOfRecords = 0
    }
    
    func updateData(successAttempts: Int, failureAttempts: Int, numberOfRecords: Int) {
        self.successAttempts = successAttempts
        self.failureAttempts = failureAttempts
        self.numberOfRecords = numberOfRecords
        statisticsViewModelDelegate?.updateStatisticsData()
    }
}
