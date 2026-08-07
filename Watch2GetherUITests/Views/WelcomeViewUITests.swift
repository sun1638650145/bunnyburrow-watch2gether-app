//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  WelcomeViewUITests.swift
//  Watch2GetherUITests
//
//  Created by Steve R. Sun on 2026/8/7.
//

import XCTest

final class WelcomeViewUITests: XCTestCase {
    /// 测试应用实例.
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["--reset_app_state"]
        app.launch()
    }

    @MainActor
    func testTappingLoginButtonDisplaysHomeView() {
        let loginButton = app.buttons["loginButton"]
        let nicknameTextField = app.textFields["nicknameTextField"]
        let webSocketUrlTextField = app.textFields["webSocketUrlTextField"]
        let videoPickerTextField = app.textFields["videoPickerTextField"]
        let homeView = app.otherElements["homeView"]
        let welcomeView = app.otherElements["welcomeView"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/ws/")

        videoPickerTextField.tap()
        videoPickerTextField.typeText("https://example.com/")

        loginButton.tap()

        // 重新启动应用, 但不再重置应用的状态.
        app.terminate()
        app.launchArguments = []
        app.launch()

        XCTAssertTrue(welcomeView.exists, "用户信息存在时, 应显示快速登录视图.")

        loginButton.tap()

        XCTAssertFalse(welcomeView.exists, "登录成功后, 不再显示快速登录视图.")
        XCTAssertTrue(homeView.exists, "登录成功后, 应显示主界面视图.")
    }
}
