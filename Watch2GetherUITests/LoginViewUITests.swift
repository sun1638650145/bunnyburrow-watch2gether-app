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
    /// 测试应用实例.
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLoginWithEmptyTextFieldDisplaysError() {
        app.buttons["loginButton"].tap()

        XCTAssertTrue(app.staticTexts["nicknameEmptyError"].exists)
    }
}
