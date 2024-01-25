//
//  DataButtonsView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import UIKit

class DataButtonsView: UIView {
    let dataButtonsViewModel: DataButtonsViewModel
    
    private let myPuzzlesButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: "figure.wave"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    private let standingsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: "trophy"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    init() {
        dataButtonsViewModel = DataButtonsViewModel()
        
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
        
        addSubview(myPuzzlesButton)
        
        myPuzzlesButton.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(50)
            make.height.equalTo(myPuzzlesButton.snp.width)
        }
        
        addSubview(standingsButton)
        
        standingsButton.snp.makeConstraints { make -> Void in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(myPuzzlesButton)
            make.height.equalTo(standingsButton.snp.width)
        }
        
        addSubview(editProfileButton)
        
        editProfileButton.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(standingsButton)
            make.trailing.equalTo(myPuzzlesButton)
            make.width.equalTo(standingsButton)
            make.height.equalTo(editProfileButton.snp.width)
        }
    }
    
    func setupUIFunctionality() {
        myPuzzlesButton.addTarget(self, action: #selector(myPuzzlesButtonPressed(sender:)), for: .touchUpInside)
        standingsButton.addTarget(self, action: #selector(standingsButtonPressed(sender:)), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(editProfileButtonPressed(sender:)), for: .touchUpInside)
    }
}

extension DataButtonsView {
    @objc func myPuzzlesButtonPressed(sender: UIButton) {
        sender.onButtonPressAnimation()
        dataButtonsViewModel.showMyPuzzles()
    }
    
    @objc func standingsButtonPressed(sender: UIButton) {
        sender.onButtonPressAnimation()
        dataButtonsViewModel.showStandings()
    }
    
    @objc func editProfileButtonPressed(sender: UIButton) {
        sender.onButtonPressAnimation()
        dataButtonsViewModel.showEditProfile()
    }
}
