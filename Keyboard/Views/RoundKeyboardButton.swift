//
//  RoundKeyboardButton.swift
//  Keyboard
//

import UIKit

/**
 A handy subclass for round-corner button
 */
@IBDesignable class RoundKeyboardButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
