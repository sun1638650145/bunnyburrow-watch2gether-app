//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  HomeViewUITests.swift
//  Watch2GetherUITests
//
//  Created by Steve R. Sun on 2026/9/29.
//

import XCTest

final class HomeViewUITests: XCTestCase {
    /// 测试应用实例.
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["--reset_app_state"]
        app.launch()
    }

    @MainActor
    func testFriendsListDetailToggle() {
        LoginUITestSupport.login(in: app)

        let homeView = app.otherElements["homeView"]

        let friendsList = homeView.otherElements["friendsList"]

        let detailToggleButton = friendsList.buttons["detailToggleButton"]
        let detailScrollView = friendsList.scrollViews["detailScrollView"]

        XCTAssertTrue(detailToggleButton.exists)
        XCTAssertTrue(detailScrollView.exists)

        detailToggleButton.tap()

        XCTAssertFalse(detailScrollView.exists)
    }

    @MainActor
    func testHomeViewDisplaysExpectedComponents() {
        LoginUITestSupport.login(in: app)

        let homeView = app.otherElements["homeView"]

        let videoPlayer = homeView.otherElements["videoPlayer"]
        let friendsList = homeView.otherElements["friendsList"]
        let conversationSpace = homeView.otherElements["conversationSpace"]

        XCTAssertTrue(videoPlayer.exists)
        XCTAssertTrue(friendsList.exists)
        XCTAssertTrue(conversationSpace.exists)
    }

    @MainActor
    func testSendingMessageEnablesSendButtonAndDisplaysMessage() {
        LoginUITestSupport.login(in: app)

        let homeView = app.otherElements["homeView"]

        let messageField = homeView.textFields["messageField"]
        let sendButton = homeView.buttons["sendButton"]

        XCTAssertFalse(sendButton.isEnabled, "聊天消息为空时, 发送按钮应禁用.")

        let message = "Hello, World!"

        messageField.tap()
        messageField.typeText(message)

        XCTAssertTrue(sendButton.isEnabled)

        sendButton.tap()

        XCTAssertEqual(messageField.value as? String, "")
        XCTAssertFalse(sendButton.isEnabled)
        XCTAssertTrue(homeView.staticTexts[message].exists)
    }
}
