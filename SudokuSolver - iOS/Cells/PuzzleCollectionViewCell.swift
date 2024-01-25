//
//  PuzzleCollectionViewCell.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 29.12.2023..
//

import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {
    var candidates: [Int] = [Int](repeating: 0, count: 9)
    
    let numberLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    private let candidatesCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    func setupUI() {
        layer.cornerRadius = 5
        
        addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        addSubview(candidatesCollectionView)
        
        candidatesCollectionView.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(2)
            make.width.equalToSuperview().offset(-4)
            make.height.equalToSuperview().offset(-4)
        }
    }
    
    func setupUIFunctionality() {
        candidatesCollectionView.isUserInteractionEnabled = false
        candidatesCollectionView.dataSource = self
        candidatesCollectionView.delegate = self
        candidatesCollectionView.register(CandidateCollectionViewCell.self, forCellWithReuseIdentifier: "candidateCell")
    }
    
    func setupUIData(number: Int, cellCandidates: [Int]) {
        numberLabel.text = number == 0 ? "" : String(number)
        candidates = number == 0 ? cellCandidates : [Int](repeating: 0, count: 9)
        
        candidatesCollectionView.reloadData()
    }
}

extension PuzzleCollectionViewCell {
    func updateBackgroundColor(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func updateTextColor(textColor: UIColor) {
        numberLabel.textColor = textColor
    }
    
    func getValue() -> Int {
        return numberLabel.text!.toInt()
    }
    
    func getCandidates() -> [Int] {
        return candidates
    }
}

extension PuzzleCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "candidateCell", for: indexPath) as! CandidateCollectionViewCell
        
        switch candidates[indexPath.row] {
            case 0:
                cell.setupUI(cellBackgroundColor: .clear)
                cell.setupUIData(number: 0)
                break
            case 1:
                cell.setupUI(cellBackgroundColor: .clear)
                cell.setupUIData(number: indexPath.row + 1)
                break
            case 2:
                cell.setupUI(cellBackgroundColor: .systemGreen)
                cell.setupUIData(number: indexPath.row + 1)
                break
            case 3:
                cell.setupUI(cellBackgroundColor: .systemBlue)
                cell.setupUIData(number: indexPath.row + 1)
                break
            case 4:
                cell.setupUI(cellBackgroundColor: .systemRed)
                cell.setupUIData(number: indexPath.row + 1)
                break
            default:
                break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 2 * 2) / 3, height: (collectionView.frame.width - 2 * 2) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
