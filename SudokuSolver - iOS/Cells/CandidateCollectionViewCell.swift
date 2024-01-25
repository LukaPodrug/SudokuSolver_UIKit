//
//  CandidateCollectionViewCell.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 29.12.2023..
//

import UIKit

class CandidateCollectionViewCell: UICollectionViewCell {
    private let candidateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 9)
        label.textAlignment = .center
        
        return label
    }()
    
    func setupUI(cellBackgroundColor: UIColor) {
        layer.cornerRadius = 4
        backgroundColor = cellBackgroundColor
        
        addSubview(candidateLabel)
        
        candidateLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setupUIData(number: Int) {
        candidateLabel.text = number == 0 ? "" : String(number)
    }
}
