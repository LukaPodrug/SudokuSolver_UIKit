//
//  PuzzleSolutionMenuView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 09.01.2024..
//

import UIKit

class PuzzleSolutionMenuView: UIView {
    let puzzleSolutionMenuViewModel: PuzzleSolutionMenuViewModel
    
    private let solutionStepTextView: UITextView = {
        let textView = UITextView()
        
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    private let nextStepButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Next step", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .black
        
        return button
    }()
    
    private let entireSolutionButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Entire solution", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .black
        
        return button
    }()
    
    init() {
        puzzleSolutionMenuViewModel = PuzzleSolutionMenuViewModel()
        
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
        
        addSubview(solutionStepTextView)
        
        solutionStepTextView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().multipliedBy(0.67).offset(-10)
            make.height.equalTo(110)
        }
        
        addSubview(nextStepButton)
        
        nextStepButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(solutionStepTextView)
            make.leading.equalTo(solutionStepTextView.snp.trailing).offset(10)
            make.width.equalToSuperview().multipliedBy(0.33).offset(-10)
            make.height.equalTo(50)
        }
        
        addSubview(entireSolutionButton)
        
        entireSolutionButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(nextStepButton.snp.bottom).offset(10)
            make.leading.equalTo(nextStepButton)
            make.width.equalTo(nextStepButton)
            make.height.equalTo(nextStepButton)
        }
    }
    
    func setupUIFunctionality() {
        solutionStepTextView.isUserInteractionEnabled = false
        nextStepButton.addTarget(self, action: #selector(showNextStep(sender:)), for: .touchUpInside)
        entireSolutionButton.addTarget(self, action: #selector(showEntirePuzzleSolution(sender:)), for: .touchUpInside)
    }
}

extension PuzzleSolutionMenuView {
    func enable() {
        nextStepButton.isEnabled = true
        entireSolutionButton.isEnabled = true
        
        nextStepButton.backgroundColor = .systemGreen
        entireSolutionButton.backgroundColor = .systemMint
    }
    
    func disable() {
        nextStepButton.isEnabled = false
        entireSolutionButton.isEnabled = false
        
        nextStepButton.backgroundColor = .systemGray3
        entireSolutionButton.backgroundColor = .systemGray3
    }
    
    func updateSolutionStepText(text: String) {
        solutionStepTextView.text = text
    }
}

extension PuzzleSolutionMenuView {
    @objc func showNextStep(sender: UIButton) {
        sender.onButtonPressAnimation()
        puzzleSolutionMenuViewModel.showNextStep()
    }
    
    @objc func showEntirePuzzleSolution(sender: UIButton) {
        sender.onButtonPressAnimation()
        puzzleSolutionMenuViewModel.showEntireSolution()
    }
}
