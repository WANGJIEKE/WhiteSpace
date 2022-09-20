//
//  ContentView.swift
//  WhiteSpace
//
//  Created by Tongjie Wang on 9/15/22.
//

import SwiftUI

struct AppMainView: View {
    @Binding var rules: [ConversionRule]
    var saveRules: () -> Void
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Custom Rules") {
                    ForEach($rules) { $rule in
                        NavigationLink(destination: RuleDetailView(rule: $rule, isPreset: false, onRuleChange: saveRules)) {
                            Text(rule.name)
                        }
                    }
                    .onDelete { indexSet in
                        rules.remove(atOffsets: indexSet)
                    }
                }
                Section("Presets") {
                    ForEach(.constant(ConversionRule.presets)) { $rule in
                        NavigationLink(destination: RuleDetailView(rule: $rule, isPreset: true)) {
                            Text(rule.name)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let rule = ConversionRule(name: "New Rule \(Date.now.formatted())", content: ConversionRule.newRuleContentTemplate)
                        rules.insert(rule, at: 0)
                        saveRules()
                        path.append(rule)
                    } label: {
                        Label("Add a new rule", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("WhiteSpace")
            .navigationDestination(for: ConversionRule.self, destination: { rule in
                if let idx = rules.firstIndex { $0.id == rule.id } {
                    RuleDetailView(rule: $rules[idx], isPreset: false, onRuleChange: saveRules)
                }
            })
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive { saveRules() }
            }
        }
    }
}

struct AppMainViewPreviewContainer: View {
    @State private var rules: [ConversionRule] = []
    
    var body: some View {
        AppMainView(rules: $rules) {}
    }
}

struct AppMainViewPreviews: PreviewProvider {
    static var previews: some View {
        AppMainViewPreviewContainer()
    }
}
