//
//  View.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 10.01.2024..
//

import Foundation
import UIKit

extension UIView {
    func onViewPressAnimation() {
        UIView.transition(
            with: self,
            duration: 0.0,
            options: .transitionCrossDissolve,
            animations: { self.alpha = 0.5 },
            completion: { _ in self.onViewAnimationEnd() }
        )
    }
    
    func onViewAnimationEnd() {
        UIView.transition(
            with: self,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: { self.alpha = 1 },
            completion: nil
        )
    }
}
