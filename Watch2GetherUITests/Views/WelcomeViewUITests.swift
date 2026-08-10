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
        let loginView = app.otherElements["loginView"]
        let homeView = app.otherElements["homeView"]
        let welcomeView = app.otherElements["welcomeView"]

        let loginButton = loginView.buttons["loginButton"]
        let quickLoginButton = welcomeView.buttons["loginButton"]

        fillInformation(in: loginView)

        loginButton.tap()

        // 重新启动应用, 但不再重置应用的状态.
        app.terminate()
        app.launchArguments = []
        app.launch()

        XCTAssertTrue(welcomeView.exists, "用户信息存在时, 应显示快速登录视图.")

        quickLoginButton.tap()

        XCTAssertFalse(welcomeView.exists, "登录成功后, 不再显示快速登录视图.")
        XCTAssertTrue(homeView.exists, "登录成功后, 应显示主界面视图.")
    }

    @MainActor
    func testTappingOptionsButtonReturnsToLoginView() {
        let loginView = app.otherElements["loginView"]
        let welcomeView = app.otherElements["welcomeView"]

        let loginButton = loginView.buttons["loginButton"]
        let optionsButton = welcomeView.buttons["optionsButton"]

        fillInformation(in: loginView)

        loginButton.tap()

        /// 重新启动应用, 但不再重置应用状态.
        app.terminate()
        app.launchArguments = []
        app.launch()

        XCTAssertTrue(welcomeView.exists, "用户信息存在时, 应显示快速登录视图.")

        optionsButton.tap()

        XCTAssertFalse(welcomeView.exists, "点击选项按钮后, 不再显示快速登录视图.")
        XCTAssertTrue(loginView.exists, "点击选项按钮后, 应返回登录页面视图.")
    }

    /// 在登录页面视图中输入用户的基本信息, WebSocket服务地址和视频源URL.
    ///
    /// - Parameters:
    ///   - loginView: 登录页面视图UI元素.
    @MainActor
    private func fillInformation(in loginView: XCUIElement) {
        let nicknameTextField = loginView.textFields["nicknameTextField"]
        let webSocketUrlTextField = loginView.textFields["webSocketUrlTextField"]
        let videoPickerTextField = loginView.textFields["videoPickerTextField"]

        nicknameTextField.tap()
        nicknameTextField.typeText("Steve")

        webSocketUrlTextField.tap()
        webSocketUrlTextField.typeText("wss://example.com/ws/")

        videoPickerTextField.tap()
        videoPickerTextField.typeText("https://example.com/")
    }
}
