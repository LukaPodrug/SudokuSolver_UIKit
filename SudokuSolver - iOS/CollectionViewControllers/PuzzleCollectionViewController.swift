//
//  PuzzleCollectionViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 08.01.2024..
//

import UIKit

protocol PuzzleCollectionViewDelegate: AnyObject {
    func selectOccupiedCellNotes(selectedPuzzleCellIndexPath: IndexPath)
    func selectFreeCellNotes(selectedPuzzleCellIndexPath: IndexPath)
    func selectOccupiedCellValue(selectedPuzzleCellIndexPath: IndexPath)
    func selectFreeCellValue(selectedPuzzleCellIndexPath: IndexPath)
}

class PuzzleCollectionViewController: UICollectionViewController {
    var puzzle: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
    var workingPuzzle: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
    
    var candidates: [[[Int]]] = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9), count: 9)
    
    var notesMode: Bool = false
    
    weak var puzzleCollectionViewDelegate: PuzzleCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIFunctionality()
    }
    
    func setupUIFunctionality() {
        collectionView.register(PuzzleCollectionViewCell.self, forCellWithReuseIdentifier: "PuzzleCell")
    }
    
    func updateData() {
        collectionView.animatedReload()
    }
}

extension PuzzleCollectionViewController {
    func updatePuzzle(puzzle: [[Int]]) {
        self.puzzle = puzzle
    }
    
    func updateWorkingPuzzle(workingPuzzle: [[Int]]) {
        self.workingPuzzle = workingPuzzle
    }
    
    func updateCandidates(candidates: [[[Int]]]) {
        self.candidates = candidates
    }
    
    func updateNotesMode(notesMode: Bool) {
        self.notesMode = notesMode
    }
    
    func updateSelectedPuzzleCellIndexPath(selectedPuzzleCellIndexPath: IndexPath?) {
        if selectedPuzzleCellIndexPath != nil {
            collectionView.reloadItems(at: [selectedPuzzleCellIndexPath!])
            collectionView.selectItem(at: selectedPuzzleCellIndexPath, animated: true, scrollPosition: .centeredVertically)
            collectionView(collectionView, didSelectItemAt: selectedPuzzleCellIndexPath!)
        }
    }
}

extension PuzzleCollectionViewController {
    func disable() {
        collectionView.isUserInteractionEnabled = false
    }
}

extension PuzzleCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as! PuzzleCollectionViewCell
        
        let darkBox = [1,4,7,9,11,12,14,15,17,19,22,25]
        
        cell.setupUI()
        cell.setupUIFunctionality()
        cell.setupUIData(number: workingPuzzle[indexPath.row / 9][indexPath.row % 9], cellCandidates: candidates[indexPath.row / 9][indexPath.row % 9])
        cell.updateBackgroundColor(backgroundColor: darkBox.contains(indexPath.row / 3) ? .systemGray2: .systemGray4)
        cell.updateTextColor(textColor: puzzle[indexPath.row / 9][indexPath.row % 9] != 0 ? .black : .systemBlue)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: PuzzleCollectionViewCell = collectionView.cellForItem(at: indexPath) as! PuzzleCollectionViewCell
        
        cell.setupUIData(number: workingPuzzle[indexPath.row / 9][indexPath.row % 9], cellCandidates: candidates[indexPath.row / 9][indexPath.row % 9])
        
        if notesMode == true {
            if workingPuzzle[indexPath.row / 9][indexPath.row % 9] == 0 {
                cell.updateBackgroundColor(backgroundColor: .systemOrange)
                puzzleCollectionViewDelegate?.selectFreeCellNotes(selectedPuzzleCellIndexPath: indexPath)
            }
            
            else {
                cell.updateBackgroundColor(backgroundColor: .systemYellow)
                puzzleCollectionViewDelegate?.selectOccupiedCellNotes(selectedPuzzleCellIndexPath: indexPath)
            }
        }
        
        else {
            if puzzle[indexPath.row / 9][indexPath.row % 9] == 0 {
                cell.updateBackgroundColor(backgroundColor: .systemCyan)
                puzzleCollectionViewDelegate?.selectFreeCellValue(selectedPuzzleCellIndexPath: indexPath)
            }
            
            else {
                cell.updateBackgroundColor(backgroundColor: .systemMint)
                puzzleCollectionViewDelegate?.selectOccupiedCellValue(selectedPuzzleCellIndexPath: indexPath)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell: PuzzleCollectionViewCell = collectionView.cellForItem(at: indexPath) as! PuzzleCollectionViewCell
        let darkBox = [1,4,7,9,11,12,14,15,17,19,22,25]
        cell.updateBackgroundColor(backgroundColor: darkBox.contains(indexPath.row / 3) ? .systemGray2: .systemGray4)
    }
}

extension PuzzleCollectionViewController: UICollectionViewDelegateFlowLayout {
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
