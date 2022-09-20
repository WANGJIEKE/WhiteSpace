//
//  RuleDetail.swift
//  WhiteSpace
//
//  Created by Tongjie Wang on 9/17/22.
//

import SwiftUI

struct RuleDetailView: View {
    @Binding var rule: ConversionRule
    let isPreset: Bool
    
    var saveRule: (() -> Void)?
    
    @State private var localRule: ConversionRule
    @State private var previewResult: Result<String, ConversionRuleEvaluation.EvalError>?
    
    init(rule: Binding<ConversionRule>, isPreset: Bool, onRuleChange saveRule: (() -> Void)? = nil) {
        self._rule = rule
        self.isPreset = isPreset
        self._localRule = State(initialValue: rule.wrappedValue)
        self._previewResult = State(initialValue: nil)
        self.saveRule = saveRule
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Name")
                    Spacer(minLength: 15)
                    HStack {
                        TextField("Rule name", text: $localRule.name, prompt: Text("Rule Name"))
                            .disabled(isPreset)
                    }
                }
                NavigationLink {
                    TextEditor(text: $localRule.content)
                        .font(.monospaced(.system(size: 15))())
                        .navigationTitle("Content")
                        .navigationBarTitleDisplayMode(.inline)
                        .disabled(isPreset)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } label: {
                    HStack {
                        Text("Content")
                        Spacer()
                        Text(isPreset ? "View" : "Edit")
                            .frame(alignment: .trailing)
                    }
                }
            }
            .onChange(of: localRule) { newRule in
                rule = newRule
                self.saveRule?()
                
                if previewResult != nil {
                    Task {
                        previewResult = await ConversionRuleEvaluation.eval(ruleContent: rule.content, input: rule.name)
                    }
                }
            }
            
            Section("Preview") {
                if let result = previewResult {
                    switch result {
                    case .success(let success):
                        Text(success)
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
            }
        }
        .navigationTitle(localRule.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .task {
            previewResult = await ConversionRuleEvaluation.eval(ruleContent: rule.content, input: rule.name)
        }
    }
}

struct RuleDetailPreviewContainer: View {
    @State private var rule = ConversionRule.presets[0]
    let isPreset: Bool
    
    var body: some View {
        RuleDetailView(rule: $rule, isPreset: isPreset)
    }
}

struct RuleDetailPreviews: PreviewProvider {
    static var previews: some View {
        RuleDetailPreviewContainer(isPreset: false)
    }
}
