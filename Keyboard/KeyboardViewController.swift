//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Tongjie Wang on 9/18/22.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController, KeyboardViewDelegate {
    var inputSwitchButton: UIButton!
    var hostingController: UIHostingController<KeyboardView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonCfg = UIButton.Configuration.bordered()
        buttonCfg.baseForegroundColor = .label
        buttonCfg.image = UIImage(systemName: "globe")
        
        inputSwitchButton = UIButton()
        inputSwitchButton.configuration = buttonCfg

        inputSwitchButton.sizeToFit()
        inputSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        inputSwitchButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        hostingController = UIHostingController(rootView: KeyboardView(delegate: self))
        hostingController.sizingOptions = .intrinsicContentSize
        hostingController.modalPresentationStyle = .currentContext
        
        hostingController.willMove(toParent: self)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: hostingController.view.heightAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    var button: UIButton? {
        return needsInputModeSwitchKey ? inputSwitchButton : nil
    }
    
    func onRuleOutputTap(output: String) {
        textDocumentProxy.insertText(output)
    }
    
    func onReturnTap() {
        textDocumentProxy.insertText("\n")
    }
    
    func onDeleteTap() {
        textDocumentProxy.deleteBackward()
    }
}
