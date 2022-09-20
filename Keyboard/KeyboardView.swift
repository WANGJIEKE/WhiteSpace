//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Tongjie Wang on 9/18/22.
//

import SwiftUI

struct KeyboardView: View {
    weak var delegate: KeyboardViewDelegate?
    
    @State private var activeRule: ConversionRule?
    @State private var userInput: String = ""
    @State private var previewResult: Result<String, ConversionRuleEvaluation.EvalError>? = nil
    
    @State private var storageLoadError: Error? = nil
    @StateObject private var storage = ConversionRuleStorage()
    
    init(delegate:  KeyboardViewDelegate? = nil) {
        self.delegate = delegate
    }
    
    var outputPreviewAndSelection: some View {
        Group {
            if let storageLoadError {
                Text(storageLoadError.localizedDescription)
                    .foregroundColor(.red)
            } else if activeRule != nil {
                if let result = previewResult {
                    switch result {
                    case .success(let output):
                        Text(output)
                            .onTapGesture {
                                delegate?.onRuleOutputTap(output: output)
                            }
                    case .failure(let failure):
                        Group {
                            switch failure {
                            case .frameworkError:
                                Text("JavaScriptCore encountered an error")
                            case .wrongReturnType:
                                Text("Your rule didn't return a string or encountered an exception")
                            }
                        }
                        .foregroundColor(.red)
                    }
                } else {
                    ProgressView()
                }
            } else {
                Text("Please select a rule to preview")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxHeight: .infinity)
        .fixedSize()
        .padding()
    }
    
    var rulesSelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(storage.rules + ConversionRule.presets) { rule in
                    Button {
                        activeRule = rule
                        Task {
                            previewResult = await ConversionRuleEvaluation.eval(ruleContent: rule.content, input: userInput)
                        }
                    } label: {
                        Text(rule.name)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.primary)
                    .brightness(rule.id == activeRule?.id ? -0.5 : 0)
                    .disabled(rule.id == activeRule?.id)
                }
            }
            .frame(alignment: .center)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
    
    var necessaryKeyboardButtons: some View {
        HStack(alignment: .center) {
            if let button = delegate?.button {
                InputMethodSwitch(button: button)
                    .frame(maxHeight: .infinity)
                    .fixedSize()
            }
            Button {
                if let newInput = UIPasteboard.general.strings?.first {
                    Task {
                        userInput = newInput
                        if let activeRule {
                            previewResult = await ConversionRuleEvaluation.eval(ruleContent: activeRule.content, input: userInput)
                        }
                    }
                }
            } label: {
                Image(systemName: "doc.on.clipboard")
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
            
            Button {
                delegate?.onReturnTap()
            } label: {
                Text("return")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                delegate?.onDeleteTap()
            } label: {
                Image(systemName: "delete.backward")
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
    
    var body: some View {
        VStack {
            outputPreviewAndSelection
            rulesSelection
            necessaryKeyboardButtons
        }
        .task {
            do {
                storage.rules = try await ConversionRuleStorage.load()
            } catch {
                switch error {
                case CocoaError.fileNoSuchFile:
                    return
                default:
                    storageLoadError = error
                }
            }
        }
    }
}

extension KeyboardView {
    struct InputMethodSwitch: UIViewRepresentable {
        var button: UIButton
        
        func makeUIView(context: Context) -> UIButton { return button }
        func updateUIView(_ uiView: UIButton, context: Context) {}
    }
}

protocol KeyboardViewDelegate: AnyObject {
    var button: UIButton? { get }
    var hasFullAccess: Bool { get }
    
    func onRuleOutputTap(output: String)
    func onReturnTap()
    func onDeleteTap()
}

struct KeyboardViewPreviews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
