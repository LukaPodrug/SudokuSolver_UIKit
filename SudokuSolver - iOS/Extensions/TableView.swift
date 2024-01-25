//
//  TableView.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 04.01.2024..
//

import Foundation
import UIKit

extension UITableView {
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
