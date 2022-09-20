//
//  ConversionRule.swift
//  WhiteSpace
//
//  Created by Tongjie Wang on 9/15/22.
//

import Foundation

public struct ConversionRule: Identifiable, Codable, Hashable {
    public let id: UUID
    public var name: String
    public var content: String
    
    public init(id: UUID = UUID(), name: String, content: String) {
        self.id = id
        self.name = name
        self.content = content
    }
}

extension ConversionRule {
    static let presets = [
        ConversionRule(name: "Whitespace", content: "const convert = x => [...x].join(' ')"),
        ConversionRule(name: "Pass Through", content: "const convert = x => x")
    ]
    
    var isPreset: Bool {
        return ConversionRule.presets.contains { $0.id == self.id }
    }
    
    static let newRuleContentTemplate = """
/**
 * Implement this JavaScript function
 */
const convert = x => x
"""
}
