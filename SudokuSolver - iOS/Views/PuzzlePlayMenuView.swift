//
//  PuzzlePlayMenuView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 09.01.2024..
//

import UIKit

class PuzzlePlayMenuView: UIView {
    let puzzlePlayMenuViewModel: PuzzlePlayMenuViewModel
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Clear", for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .black
        
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Delete", for: .normal)
        button.setImage(UIImage(systemName: "delete.left"), for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .black
        
        return button
    }()
    
    private let notesButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Notes", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .black
        
        return button
    }()
    
    init() {
        puzzlePlayMenuViewModel = PuzzlePlayMenuViewModel()
        
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
        
        addSubview(clearButton)
        
        clearButton.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().dividedBy(3).offset(-10)
            make.height.equalTo(45)
        }
        
        addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(clearButton)
            make.leading.equalTo(clearButton.snp.trailing).offset(10)
            make.width.equalTo(clearButton)
            make.height.equalTo(clearButton)
        }
        
        addSubview(notesButton)
        
        notesButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(deleteButton)
            make.leading.equalTo(deleteButton.snp.trailing).offset(10)
            make.width.equalTo(deleteButton)
            make.height.equalTo(deleteButton)
        }
    }
    
    func setupUIFunctionality() {
        clearButton.addTarget(self, action: #selector(clearPuzzle(sender:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        notesButton.addTarget(self, action: #selector(toggleNotes(sender:)), for: .touchUpInside)
        clearButton.isEnabled = true
        clearButton.backgroundColor = .systemRed
    }
}

extension PuzzlePlayMenuView {
    func updateDeleteFunction(isCellDeleteable: Bool) {
        deleteButton.isEnabled = isCellDeleteable ? true : false
        deleteButton.backgroundColor = isCellDeleteable ? .systemYellow : .systemGray3
    }
    
    func updateNotesFunction(notesMode: Bool) {
        notesButton.isEnabled = true
        notesButton.backgroundColor = notesMode ? .systemOrange : .systemGray5
    }
    
    func disable() {
        clearButton.isEnabled = false
        deleteButton.isEnabled = false
        notesButton.isEnabled = false
        
        clearButton.backgroundColor = .systemGray3
        deleteButton.backgroundColor = .systemGray3
        notesButton.backgroundColor = .systemGray3
    }
}

extension PuzzlePlayMenuView {
    @objc func clearPuzzle(sender: UIButton) {
        sender.onButtonPressAnimation()
        puzzlePlayMenuViewModel.clearPuzzle()
    }
    
    @objc func deleteCell(sender: UIButton) {
        sender.onButtonPressAnimation()
        puzzlePlayMenuViewModel.deleteCell()
    }
    
    @objc func toggleNotes(sender: UIButton) {
        sender.onButtonPressAnimation()
        puzzlePlayMenuViewModel.toggleNotes()
    }
}
