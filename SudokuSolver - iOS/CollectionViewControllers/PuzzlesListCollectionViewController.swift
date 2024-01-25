//
//  PuzzlesListCollectionViewController.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import UIKit

protocol PuzzlesListCollectionViewDelegate: AnyObject {
    func playPuzzle(puzzleData: PuzzleModel)
    func showUserModal(userId: Int)
}

class PuzzlesListCollectionViewController: UICollectionViewController {
    var ownData: UserModel = UserModel(id: 0, firstName: "", lastName: "", username: "", email: "", nationality: "", dateOfBirth: "", nationalityStanding: 0, globalStanding: 0, successAttempts: 0, failureAttempts: 0, numberOfRecords: 0)
    var puzzles: [PuzzleModel] = []
    
    weak var puzzlesListCollectionViewDelegate: PuzzlesListCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    func setupUI() {
        collectionView.backgroundColor = .systemGray6
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func setupUIFunctionality() {
        collectionView.register(PuzzlesCollectionViewCell.self, forCellWithReuseIdentifier: "PuzzlesListCell")
        collectionView.register(DefaultCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
    }
}

extension PuzzlesListCollectionViewController {
    func updateData() {
        collectionView.animatedReload()
    }
    
    func updateOwnData(ownData: UserModel) {
        self.ownData = ownData
    }
    
    func updatePuzzles(puzzles: [PuzzleModel]) {
        self.puzzles = puzzles
    }
    
    func getNumberOfItems() -> Int {
        return collectionView.numberOfItems(inSection: 0)
    }
}

extension PuzzlesListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return puzzles.count == 0 ? 1 : puzzles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! DefaultCollectionViewCell
        
        emptyCell.setupUI()
        emptyCell.setupUIData(text: "No puzzles found")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzlesListCell", for: indexPath) as! PuzzlesCollectionViewCell
        
        if puzzles.count == 0 {
            return emptyCell
        }
    
        cell.setupUIData(cellPuzzleData: puzzles[indexPath.row])
        cell.setupUI(puzzleData: puzzles[indexPath.row], ownPuzzle: ownData.id == puzzles[indexPath.row].creationUserId, ownRecord: ownData.id == puzzles[indexPath.row].recordUserId)
        cell.setupUIFunctionality()
        cell.puzzlesListCollectionViewCellDelegate = self
        
        return cell
    }
}

extension PuzzlesListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
}

extension PuzzlesListCollectionViewController: PuzzlesListCollectionViewCellDelegate {
    func playPuzzle(puzzleData: PuzzleModel) {
        puzzlesListCollectionViewDelegate?.playPuzzle(puzzleData: puzzleData)
    }
    
    func showUserModal(userId: Int) {
        puzzlesListCollectionViewDelegate?.showUserModal(userId: userId)
    }
}
