//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  LoginViewUITests.swift
//  Watch2GetherUITests
//
//  Created by Steve R. Sun on 2026/7/22.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLoginWithEmptyTextField() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["loginButton"].tap()

        XCTAssert(app.staticTexts["nicknameEmptyError"].exists)
    }
}
