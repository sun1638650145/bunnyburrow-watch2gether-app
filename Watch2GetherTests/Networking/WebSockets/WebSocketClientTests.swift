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
    func chatActionEmitsReceiveMessage() {
        let mockSocket = MockWebSocketTask()
        let webSocketClient = WebSocketClient(createSocket: { _ in
            return mockSocket
        })
        let user = User(clientID: 2026, name: "Steve")

        /// 记录接收到的聊天消息和用户的客户端ID.
        var received: (message: String, clientID: UInt)?

        webSocketClient.connect("wss://example.com/ws/", user)
        webSocketClient.on(eventName: "receiveMessage", listener: { message, clientID in
            received = (message, clientID)
        })

        let json = JSON([
            "props": ["type": "websocket.broadcast"],
            "data": [
                "action": "chat",
                "message": "Hello, World!",
                "user": [
                    "clientID": 2023
                ],
                "version": "1.1"
            ]
        ])
        let message = URLSessionWebSocketTask.Message.string(json.rawString()!)

        mockSocket.simulateSystemIncomingMessage(message)

        #expect(received?.message == json["data"]["message"].stringValue)
        #expect(received?.clientID == json["data"]["user"]["clientID"].uIntValue)
    }

    @Test
    func connect() {
        let mockSocket = MockWebSocketTask()
        let webSocketClient = WebSocketClient(createSocket: { _ in
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
        let webSocketClient = WebSocketClient(createSocket: { _ in
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

    @Test
    func reconnect() {
        let mockSocket = MockWebSocketTask()
        let webSocketClient = WebSocketClient(createSocket: { _ in
            return mockSocket
        })
        let user = User(clientID: 2026, name: "Steve")

        webSocketClient.connect("wss://example.com/ws/", user)
        webSocketClient.disconnect()
        webSocketClient.reconnect()

        #expect(mockSocket.cancelCallCount == 1)
        #expect(mockSocket.resumeCallCount == 2, "连接和重连时均会调用`resume()`.")
        #expect(mockSocket.messages.count == 3, "连接, 断开和重连各广播一条消息.")

        let message = mockSocket.messages.last

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
}
