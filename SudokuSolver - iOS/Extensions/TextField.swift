//
//  TextField.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 20.12.2023..
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(
            by: padding
        )
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(
            by: padding
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(
            by: padding
        )
    }
    
    func updateBackgroundColor(backgroundColor: UIColor) {
        UIView.transition(
            with: self,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: { self.backgroundColor = backgroundColor },
            completion: nil
        )
    }
}
