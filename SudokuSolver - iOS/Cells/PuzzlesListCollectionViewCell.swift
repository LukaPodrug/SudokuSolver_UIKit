//
//  PuzzlesListCollectionViewCell.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 25.12.2023..
//

import UIKit
import SwiftUI

protocol PuzzlesListCollectionViewCellDelegate: AnyObject {
    func playPuzzle(puzzleData: PuzzleModel)
    func showUserModal(userId: Int)
}

class PuzzlesCollectionViewCell: UICollectionViewCell {
    var puzzleData: PuzzleModel = PuzzleModel(id: 0, string: "", solvedString: "", difficulty: 0, creationDate: "", creationUserId: 0, recordUserId: 0, recordTime: 0, recordDate: "", totalSuccessAttempts: 0, totalFailureAttempts: 0, userSuccessAttempts: 0, userFailureAttempts: 0)
    
    weak var puzzlesListCollectionViewCellDelegate: PuzzlesListCollectionViewCellDelegate?
    
    private let creationTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Creation"
        label.textColor = .black
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        
        return label
    }()
    
    private let recordTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Record"
        label.textColor = .black
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        
        return label
    }()
    
    private let statisticsTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Statistic"
        label.textColor = .black
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        
        return label
    }()
    
    private let creationView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let creationDateIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        
        return label
    }()
    
    private let creationIdIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "number.circle")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    private let creationIdLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        
        return label
    }()
    
    private let recordView: UIView = {
        let view = UIView()
    
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let recordDateIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    private let recordDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        
        return label
    }()
    
    private let recordTimeIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    private let recordTimeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        
        return label
    }()
    
    private let statisticView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let donutChartHostingController: UIHostingController = {
        let hostingController = UIHostingController(rootView: DonutChart(statistics: [StatisticModel(title: "Default", value: 1, color: .gray)]))
        
        hostingController.view.backgroundColor = .clear
        
        return hostingController
    }()
    
    private let statisticLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        
        return label
    }()
    
    private let myStatisticView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let myStatisticLabel: UILabel = {
        let label = UILabel()
        
        label.text = "My statistic"
        label.textColor = .black
        label.font = label.font.withSize(12)
        
        return label
    }()
    
    private let myStatisticValueLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(12)
        
        return label
    }()
    
    private let myStatisticProgressBar: UIProgressView = {
        let progressView = UIProgressView()
        
        progressView.progressTintColor = .systemGreen
        
        return progressView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Play", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    func setupUI(puzzleData: PuzzleModel, ownPuzzle: Bool, ownRecord: Bool) {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        
        addSubview(creationTitleLabel)
        
        creationTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().offset(-7).dividedBy(3)
            make.height.equalTo(22)
        }
        
        addSubview(recordTitleLabel)
        
        recordTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationTitleLabel.snp.top)
            make.leading.equalTo(creationTitleLabel.snp.trailing).offset(5)
            make.width.equalTo(creationTitleLabel.snp.width)
            make.height.equalTo(creationTitleLabel.snp.height)
        }
        
        addSubview(statisticsTitleLabel)
        
        statisticsTitleLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(recordTitleLabel.snp.top)
            make.leading.equalTo(recordTitleLabel.snp.trailing).offset(5)
            make.width.equalTo(recordTitleLabel.snp.width)
            make.height.equalTo(recordTitleLabel.snp.height)
        }
        
        addSubview(creationView)
        
        creationView.backgroundColor = ownPuzzle ? .systemGreen : .systemGray4
        
        creationView.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationTitleLabel.snp.bottom)
            make.leading.equalTo(creationTitleLabel.snp.leading)
            make.width.equalTo(creationTitleLabel.snp.width)
            make.height.equalToSuperview().offset(-67)
        }
        
        creationView.addSubview(creationDateIcon)
        
        creationDateIcon.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        creationView.addSubview(creationDateLabel)
        
        creationDateLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationDateIcon.snp.top)
            make.leading.equalTo(creationDateIcon.snp.trailing).offset(5)
            make.width.equalToSuperview().offset(-25)
            make.height.equalTo(20)
        }
        
        creationView.addSubview(creationIdIcon)
        
        creationIdIcon.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationDateIcon.snp.bottom).offset(5)
            make.leading.equalTo(creationDateIcon.snp.leading)
            make.width.equalTo(creationDateIcon.snp.width)
            make.height.equalTo(creationDateIcon.snp.height)
        }
        
        creationView.addSubview(creationIdLabel)
        
        creationIdLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationIdIcon.snp.top)
            make.leading.equalTo(creationIdIcon.snp.trailing).offset(5)
            make.width.equalToSuperview().offset(-25)
            make.height.equalTo(20)
        }
        
        addSubview(recordView)
        
        recordView.backgroundColor = ownRecord ? .systemGreen : .systemGray4
        
        recordView.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationView.snp.top)
            make.leading.equalTo(creationView.snp.trailing).offset(5)
            make.width.equalTo(creationView.snp.width)
            make.height.equalTo(creationView.snp.height)
        }
        
        recordView.addSubview(recordDateIcon)
        
        recordDateIcon.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        recordView.addSubview(recordDateLabel)
        
        recordDateLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(recordDateIcon.snp.top)
            make.leading.equalTo(recordDateIcon.snp.trailing).offset(5)
            make.width.equalToSuperview().offset(-25)
            make.height.equalTo(20)
        }
        
        recordView.addSubview(recordTimeIcon)
        
        recordTimeIcon.snp.makeConstraints { make -> Void in
            make.top.equalTo(recordDateIcon.snp.bottom).offset(5)
            make.leading.equalTo(recordDateIcon.snp.leading)
            make.width.equalTo(recordDateIcon.snp.width)
            make.height.equalTo(recordDateIcon.snp.height)
        }
        
        recordView.addSubview(recordTimeLabel)
        
        recordTimeLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(recordTimeIcon.snp.top)
            make.leading.equalTo(recordTimeIcon.snp.trailing).offset(5)
            make.width.equalToSuperview().offset(-25)
            make.height.equalTo(20)
        }
        
        addSubview(statisticView)
        
        statisticView.snp.makeConstraints { make -> Void in
            make.top.equalTo(recordView.snp.top)
            make.leading.equalTo(recordView.snp.trailing).offset(5)
            make.width.equalTo(recordView.snp.width)
            make.height.equalTo(recordView.snp.height)
        }
        
        statisticView.addSubview(donutChartHostingController.view)
        
        donutChartHostingController.view.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(donutChartHostingController.view.snp.height).offset(-10)
            make.height.equalToSuperview()
        }
        
        statisticView.addSubview(statisticLabel)
        
        statisticLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalTo(donutChartHostingController.view.snp.trailing).offset(10)
        }
        
        addSubview(myStatisticView)
        
        myStatisticView.snp.makeConstraints { make -> Void in
            make.top.equalTo(creationView.snp.bottom).offset(5)
            make.leading.equalTo(creationView.snp.leading)
            make.trailing.equalTo(recordView.snp.trailing)
            make.height.equalTo(35)
        }
        
        myStatisticView.addSubview(myStatisticLabel)
        
        myStatisticLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.height.equalTo(12)
        }
        
        myStatisticView.addSubview(myStatisticValueLabel)
        
        myStatisticValueLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(myStatisticLabel.snp.top)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(12)
        }
        
        addSubview(myStatisticProgressBar)
        myStatisticProgressBar.trackTintColor = (puzzleData.userFailureAttempts + puzzleData.userSuccessAttempts == 0) ? .systemGray : .systemRed
        
        myStatisticProgressBar.snp.makeConstraints { make -> Void in
            make.top.equalTo(myStatisticLabel.snp.bottom).offset(5)
            make.leading.equalTo(myStatisticLabel.snp.leading)
            make.trailing.equalTo(myStatisticValueLabel.snp.trailing)
            make.height.equalTo(3)
        }
        
        addSubview(playButton)
        
        playButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(myStatisticView.snp.top)
            make.leading.equalTo(myStatisticView.snp.trailing).offset(5)
            make.width.equalTo(statisticView.snp.width)
            make.height.equalTo(35)
        }
    }
    
    func setupUIFunctionality() {
        let creationTapRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCreationUserModal(sender:)))
        creationView.addGestureRecognizer(creationTapRecognizer)
        
        let recordTapRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showRecordUserModal(sender:)))
        recordView.addGestureRecognizer(recordTapRecognizer)
        
        playButton.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
    }
    
    func setupUIData(cellPuzzleData: PuzzleModel) {
        puzzleData = cellPuzzleData
        
        creationDateLabel.text = puzzleData.creationDate.toDateString()
        creationIdLabel.text = String(puzzleData.id)
        
        recordDateLabel.text = puzzleData.recordDate.toDateString()
        recordTimeLabel.text = puzzleData.recordTime.secondsToTime()
        
        donutChartHostingController.rootView = DonutChart(statistics: [StatisticModel(title: "Success", value: puzzleData.totalSuccessAttempts, color: .green), StatisticModel(title: "Failure", value: puzzleData.totalFailureAttempts, color: .red), StatisticModel(title: "Default", value: (puzzleData.totalSuccessAttempts + puzzleData.totalFailureAttempts) == 0 ? 1 : 0, color: .gray)])
        statisticLabel.text = String(puzzleData.totalSuccessAttempts) + " / " + String(puzzleData.totalSuccessAttempts + puzzleData.totalFailureAttempts)

        myStatisticProgressBar.setProgress((puzzleData.userFailureAttempts + puzzleData.userSuccessAttempts == 0) ? 0 : Float(puzzleData.userSuccessAttempts) / Float((puzzleData.userFailureAttempts + puzzleData.userSuccessAttempts)), animated: false)
        myStatisticValueLabel.text = String(puzzleData.userSuccessAttempts) + " / " + String(puzzleData.userSuccessAttempts + puzzleData.userFailureAttempts)
    }
    
    @objc func showCreationUserModal(sender: UITapGestureRecognizer) {
        sender.view!.onViewPressAnimation()
        puzzlesListCollectionViewCellDelegate?.showUserModal(userId: puzzleData.creationUserId)
    }
    
    @objc func showRecordUserModal(sender: UITapGestureRecognizer) {
        if puzzleData.recordUserId != nil {
            sender.view!.onViewPressAnimation()
            puzzlesListCollectionViewCellDelegate?.showUserModal(userId: (puzzleData.recordUserId)!)
        }
    }
    
    @objc func play(sender: UIButton) {
        sender.onButtonPressAnimation()
        puzzlesListCollectionViewCellDelegate?.playPuzzle(puzzleData: puzzleData)
    }
}
