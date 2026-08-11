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
        app.launchArguments = ["--reset_app_state"]
        app.launch()
    }

    @MainActor
    func testClearButtonVisibility() {
        let loginView = app.otherElements["loginView"]

        let clearButton = loginView.buttons["clearButton"]
        let nicknameTextField = loginView.textFields["nicknameTextField"]

        XCTAssertFalse(clearButton.exists, "未输入任何信息时, 不应显示清空按钮.")

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        XCTAssertTrue(clearButton.exists, "输入任何信息后, 应显示清空按钮.")
    }

    @MainActor
    func testInvalidStreamingUrlDisplaysError() {
        let loginView = app.otherElements["loginView"]

        let nicknameTextField = loginView.textFields["nicknameTextField"]
        let webSocketUrlTextField = loginView.textFields["webSocketUrlTextField"]
        let videoPickerTextField = loginView.textFields["videoPickerTextField"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/ws/")

        videoPickerTextField.tap()
        videoPickerTextField.typeText("oceans.mp4")

        XCTAssertTrue(loginView.staticTexts["streamingUrlInvalid"].exists)
    }

    @MainActor
    func testInvalidWebSocketUrlDisplaysError() {
        let loginView = app.otherElements["loginView"]

        let nicknameTextField = loginView.textFields["nicknameTextField"]
        let webSocketUrlTextField = loginView.textFields["webSocketUrlTextField"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/")

        XCTAssertTrue(loginView.staticTexts["webSocketUrlInvalid"].exists)
    }

    @MainActor
    func testLoginWithEmptyTextFieldDisplaysError() {
        let loginView = app.otherElements["loginView"]

        loginView.buttons["loginButton"].tap()

        XCTAssertTrue(loginView.staticTexts["nicknameEmpty"].exists)
    }

    @MainActor
    func testLoginWithValidInformationDisplaysHomeView() {
        let loginView = app.otherElements["loginView"]
        let homeView = app.otherElements["homeView"]

        let loginButton = loginView.buttons["loginButton"]

        LoginUITestSupport.fillInformation(in: loginView)

        loginButton.tap()

        XCTAssertFalse(loginView.exists, "登录成功后, 不再显示登录页面视图.")
        XCTAssertTrue(homeView.exists, "登录成功后, 应显示主界面视图.")
    }

    @MainActor
    func testTappingClearButtonClearsUserInput() {
        let loginView = app.otherElements["loginView"]

        let clearButton = loginView.buttons["clearButton"]
        let nicknameTextField = loginView.textFields["nicknameTextField"]
        let webSocketUrlTextField = loginView.textFields["webSocketUrlTextField"]
        let videoPickerTextField = loginView.textFields["videoPickerTextField"]

        LoginUITestSupport.fillInformation(in: loginView)

        clearButton.tap()

        XCTAssertFalse(clearButton.exists, "清空信息后, 不再显示清空按钮.")
        XCTAssertEqual(nicknameTextField.value as? String, "")
        XCTAssertEqual(webSocketUrlTextField.value as? String, "")
        XCTAssertEqual(videoPickerTextField.value as? String, "")
    }
}
