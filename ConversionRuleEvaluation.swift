//
//  ConversionRuleEval.swift
//  WhiteSpace
//
//  Created by Tongjie Wang on 9/18/22.
//

import Foundation
import JavaScriptCore

public enum ConversionRuleEvaluation {
    public static func eval(ruleContent: String, input: String) async -> Result<String, EvalError> {
        guard let context = JSContext() else { return .failure(.frameworkError) }
        context.evaluateScript(ruleContent)
        context.setObject(input, forKeyedSubscript: "ruleInput" as NSString)
        guard let ruleExecResult = context.evaluateScript("convert(ruleInput)") else { return .failure(.wrongReturnType) }
        return ruleExecResult.isString ? .success(ruleExecResult.toString()) : .failure(.wrongReturnType)
    }
    
    public enum EvalError: Error {
        case frameworkError, wrongReturnType
    }
}
