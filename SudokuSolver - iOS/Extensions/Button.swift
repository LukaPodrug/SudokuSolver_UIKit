//
//  Button.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 07.01.2024..
//

import Foundation
import UIKit

extension UIButton {
    func onButtonPressAnimation() {
        UIView.transition(
            with: self,
            duration: 0.0,
            options: .transitionCrossDissolve,
            animations: { self.alpha = 0.5 },
            completion: { _ in self.onButtonAnimationEnd() }
        )
    }
    
    func onButtonAnimationEnd() {
        UIView.transition(
            with: self,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: { self.alpha = 1 },
            completion: nil
        )
    }
}
