//
//  WhiteSpaceApp.swift
//  WhiteSpace
//
//  Created by Tongjie Wang on 9/15/22.
//

import SwiftUI

@main
struct WhiteSpaceApp: App {
    @StateObject private var storage = ConversionRuleStorage()
    
    @State private var err: Error? = nil
    
    var body: some Scene {
        WindowGroup {
            AppMainView(rules: $storage.rules) {
                Task {
                    do {
                        try await ConversionRuleStorage.save(rules: storage.rules)
                    } catch {
                        err = error
                    }
                }
            }
            .task {
                do {
                    storage.rules = try await ConversionRuleStorage.load()
                } catch {
                    switch error {
                    case CocoaError.fileNoSuchFile:
                        // Try create the file
                        do {
                            try await ConversionRuleStorage.save(rules: [])
                        } catch let saveErr {
                            err = saveErr
                        }
                    default:
                        err = error
                    }
                }
            }
            .alert("Error", isPresented: .constant(err != nil)) {
                Button("OK") {}
            } message: {
                Text(err?.localizedDescription ?? "")
            }
        }
    }
}
