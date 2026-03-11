//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  WebSocketClientTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/10.
//

import Foundation
import Testing

import SwiftyJSON

@testable import Watch2Gether

struct WebSocketClientTests {
    @Test
    func connect() {
        let mockSocket = MockWebSocketTask()
        let webSocketClient = WebSocketClient(makeSocket: { _ in
            return mockSocket
        })
        let user = User(clientID: 2026, name: "Steve")

        webSocketClient.connect("wss://example.com/ws/", user)

        #expect(mockSocket.resumeCallCount == 1)

        let message = mockSocket.messages.first

        switch message {
        case .string(let string):
            let json = JSON(string.data(using: .utf8)!)

            #expect(json["props"]["type"] == "websocket.broadcast")
            #expect(json["data"]["action"] == "connect")
            #expect(json["data"]["status"] == "login")
            #expect(json["data"]["user"]["clientID"].uIntValue == user.clientID)
            #expect(json["data"]["version"] == "1.1.0")
        default:
            #expect(Bool(false), "WebSocket消息应为字符串类型.")
        }
    }

    @Test
    func disconnect() {
        let mockSocket = MockWebSocketTask()
        let webSocketClient = WebSocketClient(makeSocket: { _ in
            return mockSocket
        })
        let user = User(clientID: 2026, name: "Steve")

        /// 记录是否触发`offlineAllFriends`事件.
        var didEmitOfflineAllFriends: Bool = false

        webSocketClient.connect("wss://example.com/ws/", user)
        webSocketClient.on(eventName: "offlineAllFriends", listener: {
            didEmitOfflineAllFriends = true
        })

        webSocketClient.disconnect()

        #expect(mockSocket.cancelCallCount == 1)
        #expect(mockSocket.messages.count == 2, "连接和断开各广播一条消息.")
        #expect(didEmitOfflineAllFriends == true)

        let message = mockSocket.messages.last

        switch message {
        case .string(let string):
            let json = JSON(string.data(using: .utf8)!)

            #expect(json["props"]["type"] == "websocket.broadcast")
            #expect(json["data"]["action"] == "connect")
            #expect(json["data"]["status"] == "logout")
            #expect(json["data"]["user"]["clientID"].uIntValue == user.clientID)
            #expect(json["data"]["version"] == "1.1.0")
        default:
            #expect(Bool(false), "WebSocket消息应为字符串类型.")
        }
    }
}
