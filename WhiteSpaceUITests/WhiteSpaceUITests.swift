//
//  WhiteSpaceUITests.swift
//  WhiteSpaceUITests
//
//  Created by Tongjie Wang on 6/19/23.
//

import XCTest

final class WhiteSpaceUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        
    }
}
