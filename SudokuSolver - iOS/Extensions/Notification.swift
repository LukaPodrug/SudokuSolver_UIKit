//
//  Notification.swift
//  SudokuSolver - iOS
//
//  Created by Luka Podrug on 11.01.2024..
//

import Foundation
import UIKit

extension NSNotification {
    func getKeyboardHeight() -> CGFloat {
        let userInfo: [AnyHashable : Any]? = self.userInfo
        
        if userInfo == nil {
            return 0
        }
        
        var keyboardFrame: CGRect = (userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = UIView().convert(keyboardFrame, from: nil)
        
        return keyboardFrame.size.height
    }
}
