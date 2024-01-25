//
//  CollectionView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 03.01.2024..
//

import Foundation
import UIKit

extension UICollectionView {
    func animatedReload() {
        UIView.transition(
            with: self,
            duration: 0.2,
            options: .transitionCrossDissolve, 
            animations: { self.reloadData() },
            completion: nil
        )
    }
}
