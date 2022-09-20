//
//  ConversionRuleStorage.swift
//  WhiteSpace
//
//  Created by Tongjie Wang on 9/17/22.
//

import Foundation
import SwiftUI

class ConversionRuleStorage: ObservableObject {
    @Published var rules: [ConversionRule] = []
    
    static func load() async throws -> [ConversionRule] {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let fileURL = fileURL()
                let file = try FileHandle(forReadingFrom: fileURL)
                let loadedRules = try JSONDecoder().decode([ConversionRule].self, from: file.availableData)
                continuation.resume(returning: loadedRules)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    static func save(rules: [ConversionRule]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let data = try JSONEncoder().encode(rules)
                let fileURL = fileURL()
                try data.write(to: fileURL)
                continuation.resume(returning: ())
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private static func fileURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tongjiew.whitespace")!
            .appending(path: "rules.data.json")
    }
}
