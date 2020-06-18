//
//  WhiteSpaceKeyboardView.swift
//  Keyboard
//

import UIKit

class WhiteSpaceKeyboardView: UIView {
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var nextKeyboardButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var enterButtonToNextKeyboardButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var enterButtonToParentConstraint: NSLayoutConstraint!
    
    /**
     Set if the keyboard needs to render next input method button
     
     In some newer iPhone models (iPhone X or later), the input method button is managed by iOS.
     We don't need to render a input method switch button on those devices.
     
     - Parameter isVisible: `true` if we need the switch button; `false` otherwise
     */
    func setNextKeyboardButtonVisible(_ isVisible: Bool) {
        nextKeyboardButton.isHidden = !isVisible
        enterButtonToNextKeyboardButtonConstraint.isActive = isVisible
        enterButtonToParentConstraint.isActive = !isVisible
    }
}
