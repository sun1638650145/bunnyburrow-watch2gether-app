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
    func testInvalidWebSocketUrlDisplaysError() {
        let clearButton = app.buttons["clearButton"]

        XCTAssertFalse(clearButton.exists, "未输入任何信息时, 不应显示清空按钮.")

        let nicknameTextField = app.textFields["nicknameTextField"]
        let webSocketUrlTextField = app.textFields["webSocketUrlTextField"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/")

        XCTAssertTrue(app.staticTexts["webSocketUrlInvalid"].exists)
        XCTAssertTrue(clearButton.exists, "输入任何信息后, 应显示清空按钮.")
    }

    @MainActor
    func testInvalidStreamingUrlDisplaysError() {
        let nicknameTextField = app.textFields["nicknameTextField"]
        let webSocketUrlTextField = app.textFields["webSocketUrlTextField"]
        let videoPickerTextField = app.textFields["videoPickerTextField"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/ws/")

        videoPickerTextField.tap()
        videoPickerTextField.typeText("oceans.mp4")

        XCTAssertTrue(app.staticTexts["streamingUrlInvalid"].exists)
    }

    @MainActor
    func testLoginWithEmptyTextFieldDisplaysError() {
        app.buttons["loginButton"].tap()

        XCTAssertTrue(app.staticTexts["nicknameEmpty"].exists)
    }
}
