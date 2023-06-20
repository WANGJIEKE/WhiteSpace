//
//  WhiteSpaceTests.swift
//  WhiteSpaceTests
//
//  Created by Tongjie Wang on 6/19/23.
//

import XCTest
import WhiteSpace

final class WhiteSpaceTests: XCTestCase {
    func testConversionRuleEvaluation() throws {
        let expectation = XCTestExpectation(description: "JavaScript timeout")
        let jsRule = """
const convert = x => [...x].join(' ')
"""
        let task = Task {
            let result = await ConversionRuleEvaluation.eval(ruleContent: jsRule, input: "hello world")
            switch result {
            case .success(let success):
                XCTAssertEqual("h e l l o   w o r l d", success)
            case .failure(let failure):
                XCTFail("error when executing JavaScript rule: \(failure)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        task.cancel()
    }
}
