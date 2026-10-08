//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  LoginUITestSupport.swift
//  Watch2GetherUITests
//
//  Created by Steve R. Sun on 2026/8/11.
//

import XCTest

/// 登录相关UI测试的共享辅助方法.
enum LoginUITestSupport {
    /// 在登录页面视图中输入用户的基本信息, WebSocket服务地址和视频源URL.
    ///
    /// - Parameters:
    ///   - loginView: 登录页面视图UI元素.
    @MainActor
    static func fillInformation(in loginView: XCUIElement) {
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

    /// 在登录页面视图中输入用户的基本信息并登录.
    ///
    /// - Parameters:
    ///   - app: 测试应用实例.
    @MainActor
    static func login(in app: XCUIApplication) {
        let loginView = app.otherElements["loginView"]

        fillInformation(in: loginView)

        loginView.buttons["loginButton"].tap()
    }
}
