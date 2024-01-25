//
//  NumpadCollectionViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import UIKit

protocol NumpadCollectionViewDelegate: AnyObject {
    func updatePuzzle(value: Int)
    func updateCandidates(value: Int)
}

class NumpadCollectionViewController: UICollectionViewController {
    var notesMode: Bool = false
    var selectedPuzzleCell: PuzzleCollectionViewCell? = nil
    var hardcodedPuzzleCell: Bool = false
    
    weak var numpadCollectionViewDelegate: NumpadCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIFunctionality()
    }
    
    func setupUIFunctionality() {
        collectionView.register(NumpadCollectionViewCell.self, forCellWithReuseIdentifier: "NumpadCell")
    }
    
    func updateData() {
        collectionView.animatedReload()
    }
}

extension NumpadCollectionViewController {
    func disable() {
        collectionView.isUserInteractionEnabled = false
        
    }
    
    func enable() {
        collectionView.isUserInteractionEnabled = true
    }
    
    func updateNotesMode(notesMode: Bool) {
        self.notesMode = notesMode
    }
    
    func updateSelectedCell(selectedPuzzleCell: PuzzleCollectionViewCell?) {
        self.selectedPuzzleCell = selectedPuzzleCell
    }
    
    func updateHardcodedPuzzleCell(hardcodedPuzzleCell: Bool) {
        self.hardcodedPuzzleCell = hardcodedPuzzleCell
    }
}

extension NumpadCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumpadCell", for: indexPath) as! NumpadCollectionViewCell
        
        cell.setupUI()
        cell.setupNumber(number: indexPath.row + 1)
        cell.setupBackgroundColor(backgroundColor: .systemGray3)
        
        if selectedPuzzleCell != nil && hardcodedPuzzleCell == false {
            let puzzleCellCandidates: [Int] = (selectedPuzzleCell?.getCandidates())!
            let puzzleCellValue: Int = (selectedPuzzleCell?.getValue())!
            
            if notesMode == true && puzzleCellValue == 0 {
                puzzleCellCandidates[indexPath.row] == 0 ? cell.setupBackgroundColor(backgroundColor: .systemGreen) : cell.setupBackgroundColor(backgroundColor: .systemTeal)
            }
            
            else {
                puzzleCellValue == indexPath.row + 1 ? cell.setupBackgroundColor(backgroundColor: .systemTeal) : cell.setupBackgroundColor(backgroundColor: .systemGreen)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if notesMode == true {
            numpadCollectionViewDelegate?.updateCandidates(value: indexPath.row)
        }
        
        else {
            numpadCollectionViewDelegate?.updatePuzzle(value: indexPath.row + 1)
        }
    }
}

extension NumpadCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 8 * 3) / 9, height: (collectionView.frame.width - 8 * 3) / 9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
