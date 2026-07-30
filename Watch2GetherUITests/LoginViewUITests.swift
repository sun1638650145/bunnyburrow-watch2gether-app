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
        app.launchArguments = ["--ui_testing"]
        app.launch()
    }

    @MainActor
    func testLoginWithEmptyTextFieldDisplaysError() {
        app.buttons["loginButton"].tap()

        XCTAssertTrue(app.staticTexts["nicknameEmptyError"].exists)
    }

    @MainActor
    func testInvalidWebSocketUrlDisplaysError() {
        let clearButton = app.buttons["clearButton"]

        XCTAssertFalse(clearButton.exists, "未输入任何信息时, 不应显示清空按钮.")

        let nicknameTextField = app.textFields["nicknameTextField"]
        let webSocketUrlTextField = app.textFields["webSocketUrlTextField"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/")

        XCTAssertTrue(app.staticTexts["webSocketUrlInvalidError"].exists)
        XCTAssertTrue(clearButton.exists, "输入任何信息后, 应显示清空按钮.")
    }
}
