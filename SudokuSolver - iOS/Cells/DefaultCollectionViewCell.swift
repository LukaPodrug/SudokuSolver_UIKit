//
//  DefaultCollectionViewCell.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 27.12.2023..
//

import UIKit

class DefaultCollectionViewCell: UICollectionViewCell {
    private let notificationLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = label.font.withSize(15)
        label.textAlignment = .center
        
        return label
    }()
    
    func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        
        addSubview(notificationLabel)
        
        notificationLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func setupUIData(text: String) {
        notificationLabel.text = text
    }
}
