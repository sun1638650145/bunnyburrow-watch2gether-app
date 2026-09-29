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
    func testHomeViewDisplaysExpectedComponents() {
        let loginView = app.otherElements["loginView"]
        let homeView = app.otherElements["homeView"]

        let loginButton = loginView.buttons["loginButton"]
        let videoPlayer = homeView.otherElements["videoPlayer"]
        let friendsList = homeView.otherElements["friendsList"]
        let conversationSpace = homeView.otherElements["conversationSpace"]

        LoginUITestSupport.fillInformation(in: loginView)

        loginButton.tap()

        XCTAssertTrue(videoPlayer.exists)
        XCTAssertTrue(friendsList.exists)
        XCTAssertTrue(conversationSpace.exists)
    }
}
