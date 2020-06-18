//
//  KeyboardViewController.swift
//  Keyboard
//

import UIKit

class KeyboardViewController: UIInputViewController {
    var whiteSpaceKeyboardView: WhiteSpaceKeyboardView!
    var pasteBoardText: String?
    
    var pasteBoardTimer: Timer!
    var deleteButtonTimer: Timer!
    var whiteSpace: WhiteSpace!
    
    // MARK: - Set up view
    
    override func viewDidLoad() {
        super.viewDidLoad()

        whiteSpace = WhiteSpace()
        guard let inputView = inputView else { return }
        
        let nib = UINib(nibName: "WhiteSpaceKeyboardView", bundle: nil)
        whiteSpaceKeyboardView = nib.instantiate(withOwner: nil, options: nil).first as? WhiteSpaceKeyboardView
        whiteSpaceKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        inputView.addSubview(whiteSpaceKeyboardView)
        
        NSLayoutConstraint.activate([
            whiteSpaceKeyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
            whiteSpaceKeyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
            whiteSpaceKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
            whiteSpaceKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
        ])
        
        whiteSpaceKeyboardView.previewButton.addTarget(self, action: #selector(onKeyboardViewPreviewButtonPressed), for: .touchUpInside)
        whiteSpaceKeyboardView.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        whiteSpaceKeyboardView.enterButton.addTarget(self, action: #selector(onKeyboardViewEnterButtonPressed), for: .touchUpInside)
        whiteSpaceKeyboardView.deleteButton.addTarget(self, action: #selector(onKeyboardViewDeleteButtonTapped), for: .touchUpInside)

        let deleteButtonLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onKeyboardViewDeleteButtonLongPressed))
        whiteSpaceKeyboardView.deleteButton.addGestureRecognizer(deleteButtonLongPressRecognizer)
        
        updatePasteBoardTextFromPasteBoard()
        whiteSpaceKeyboardView.setNextKeyboardButtonVisible(needsInputModeSwitchKey)
        
        /// 不知道为什么不能用 `NotificationCenter.default.addObserver`
        /// 只能用这种感觉不是很优雅的方法获取剪贴板的内容
        pasteBoardTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updatePasteBoardTextFromPasteBoard()
        }
        
        /// 無駄無駄無駄無駄無駄（迫真
        // NotificationCenter.default.addObserver(
        //     self,
        //     selector: #selector(onPasteBoardChanged(notification:)),
        //     name: UIPasteboard.changedNotification,
        //     object: nil
        // )
    }
    
    // MARK: - Response KeyboardView Events
    
    // @objc func onPasteBoardChanged(notification: NSNotification) {
    //     updatePasteBoardTextFromPasteBoard()
    // }
    
    func updatePasteBoardTextFromPasteBoard() {
        if hasFullAccess {
            whiteSpaceKeyboardView.previewButton.isEnabled = true
            whiteSpaceKeyboardView.previewButton.setTitleColor(.label, for: .normal)
            let newPasteBoardText = UIPasteboard.general.string
            if pasteBoardText != newPasteBoardText {
                pasteBoardText = newPasteBoardText
                whiteSpaceKeyboardView.previewButton.setTitle(whiteSpace.getWhiteSpacedString(from: pasteBoardText ?? ""), for: .normal)
            }
        } else {
            whiteSpaceKeyboardView.previewButton.setTitle(
                NSLocalizedString("Enable Full Access for getting input from pasteboard", comment: ""),
                for: .normal
            )
            whiteSpaceKeyboardView.previewButton.setTitleColor(.systemGray, for: .normal)
            whiteSpaceKeyboardView.previewButton.isEnabled = false
            pasteBoardText = ""
        }
    }
    
    @IBAction func onKeyboardViewEnterButtonPressed() {
        textDocumentProxy.insertText("\n")
    }
    
    @IBAction func onKeyboardViewPreviewButtonPressed() {
        if let documentContextBeforeInput = textDocumentProxy.documentContextBeforeInput {
            if !documentContextBeforeInput.hasSuffix(String(repeating: whiteSpace.setting.character.rawValue, count: whiteSpace.setting.count)) {
                textDocumentProxy.insertText(String(repeating: whiteSpace.setting.character.rawValue, count: whiteSpace.setting.count))
            }
        }
        textDocumentProxy.insertText(whiteSpace.getWhiteSpacedString(from: pasteBoardText ?? ""))
    }
    
    @IBAction func onKeyboardViewDeleteButtonTapped() {
        textDocumentProxy.deleteBackward()
    }
    
    @IBAction func onKeyboardViewDeleteButtonLongPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            deleteButtonTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                self.textDocumentProxy.deleteBackward()
            })
        } else if gesture.state == .ended || gesture.state == .cancelled {
            deleteButtonTimer?.invalidate()
            deleteButtonTimer = nil
        }
    }
    
    // MARK: - Clean up Paste Board Listener
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pasteBoardTimer?.invalidate()
        pasteBoardTimer = nil
    }
    
    deinit {
        pasteBoardTimer?.invalidate()
        pasteBoardTimer = nil
    }
}
