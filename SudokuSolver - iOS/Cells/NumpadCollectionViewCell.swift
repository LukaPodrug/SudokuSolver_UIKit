//
//  NumpadCollectionViewCell.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 30.12.2023..
//

import UIKit

class NumpadCollectionViewCell: UICollectionViewCell {
    let numberLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    func setupUI() {
        layer.cornerRadius = 10
        
        addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setupNumber(number: Int) {
        numberLabel.text = String(number)
    }
    
    func setupBackgroundColor(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}
