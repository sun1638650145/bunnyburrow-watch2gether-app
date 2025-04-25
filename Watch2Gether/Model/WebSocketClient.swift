//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  WebSocketClient.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/19.
//

import Combine
import Foundation
import Observation

import SwiftyJSON

/// WebSocket客户端.
@Observable
class WebSocketClient {
    /// 用户信息.
    var user: User?

    /// 用于存储事件监听器的取消器集合.
    private var cancellables = Set<AnyCancellable>()

    /// 事件监听器字典, 键为事件名称, 值为携带返回值的回调函数.
    private var eventListeners: [String: (Any) -> Any] = [:]

    /// 事件发布者字典, 键为事件名称, 值为`PassthroughSubject`.
    private var eventPublishers: [String: PassthroughSubject<Any, Never>] = [:]

    /// 从WebSocket服务器接收到的消息的事件发布者.
    private var messagePublisher = PassthroughSubject<URLSessionWebSocketTask.Message, Never>()

    /// 当前的WebSocket任务.
    private var socket: URLSessionWebSocketTask?

    /// WebSocket服务地址.
    private var url: String?

    /// WebSocket数据格式版本.
    private var version: String = "1.1"

    /// 向WebSocket服务器广播数据.
    ///
    /// - Parameters:
    ///   - data: 广播的数据.
    ///
    /// - Important:
    ///   调用该方法前请确保WebSocket连接已建立, 否则会导致程序崩溃.
    func broadcast(_ data: JSON) {
        guard let socket = socket
        else {
            fatalError("尚未建立WebSocket连接!")
        }

        let json = JSON([
            "props": ["type": "websocket.broadcast"],
            "data": data
        ])

        guard let rawString = json.rawString()
        else {
            fatalError("无法将JSON数据转换成字符串!")
        }

        let message = URLSessionWebSocketTask.Message.string(rawString)
        socket.send(message, completionHandler: { error in
            if let error = error {
                print("广播消息失败: \(error.localizedDescription)")
            }
        })
    }

    /// 建立WebSocket连接.
    ///
    /// - Parameters:
    ///   - url: WebSocket服务地址.
    ///   - user: 用户信息.
    func connect(_ url: String, _ user: User) {
        let session = URLSession(configuration: .default)

        /// 使用专属的WebSocket服务地址.
        self.socket = session.webSocketTask(with: URL(string: url + String(user.clientID) + "/")!)
        self.url = url
        self.user = user

        /// WebSocket连接成功后, 自动向服务器发送登录用户的信息.
        self.socket?.resume()
        self.broadcast([
            "action": "connect",
            "status": "login",
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": user.clientID
            ],
            "version": version
        ])

        /// 接收并处理WebSocket服务器的消息.
        self.receiveMessage()
        self.handleWebSocketMessage()
    }

    /// 断开与WebSocket服务器的连接.
    func disconnect() {
        guard let socket = socket
        else {
            print("没有可断开的WebSocket连接.")
            return
        }

        self.broadcast([
            "action": "connect",
            "status": "logout",
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": self.user!.clientID
            ],
            "version": version
        ])

        /// 将所有的好友标记为离线.
        self.emit(eventName: "offlineAllFriends", params: ())

        socket.cancel()
        self.socket = nil
    }

    /// 添加事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - listener: 回调函数.
    func on<T>(eventName: String, listener: @escaping (T) -> Void) {
        let publisher = PassthroughSubject<Any, Never>()

        publisher
            /// 确保数据类型和回调函数的期望类型一致.
            .compactMap({ $0 as? T })

            /// 将收到的数据传递给回调函数.
            .sink(receiveValue: listener)

            /// 将事件监听器保存到取消器集合中.
            .store(in: &cancellables)

        eventPublishers[eventName] = publisher
    }

    /// 添加携带返回值的事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - listener: 携带返回值的回调函数.
    func on<T, U>(eventName: String, listener: @escaping (T) -> U) {
        eventListeners[eventName] = { params in
            guard let params = params as? T
            else {
                fatalError("事件监听器\(eventName)的参数类型无效!")
            }

            return listener(params)
        }
    }

    /// 重新建立WebSocket连接.
    func reconnect() {
        guard let url = self.url, let user = self.user
        else {
            print("WebSocket服务地址或用户信息尚未初始化!")
            return
        }

        let session = URLSession(configuration: .default)

        self.socket = session.webSocketTask(with: URL(string: url + String(user.clientID) + "/")!)
        self.socket?.resume()

        self.broadcast([
            "action": "connect",
            "status": "login",
            "user": user.toJSON(),
            "version": version
        ])

        self.receiveMessage()
    }

    /// 触发事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - params: 传递给回调函数的参数.
    private func emit<T>(eventName: String, params: T) {
        guard let publisher = self.eventPublishers[eventName]
        else {
            return
        }

        /// 通过发布者发送参数.
        publisher.send(params)
    }

    /// 触发事件监听器, 并返回结果.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - params: 传递给回调函数的参数.
    /// - Returns: 回调函数返回的结果.
    private func emit<T, U>(eventName: String, params: T) -> U? {
        guard let listener = self.eventListeners[eventName]
        else {
            return nil
        }

        return listener(params) as? U
    }

    /// 处理WebSocket服务器操作类型为`chat`的消息, `chat`操作用于处理聊天消息.
    ///
    /// - Parameters:
    ///   - data: 收到的数据.
    private func handleChatAction(_ data: JSON) {
        /// 接收聊天消息.
        self.emit(
            eventName: "receiveMessage",
            params: (data["message"].stringValue, data["user"]["clientID"].uIntValue)
        )
    }

    /// 处理WebSocket服务器操作类型为`connect`的消息, `connect`操作用于管理WebSocket连接状态, 包括登录, 确认(回应), 登出和请求.
    ///
    /// - Parameters:
    ///   - data: 收到的数据.
    private func handleConnectAction(_ data: JSON) {
        if data["status"] == "ack" {
            /// 添加好友或更新状态.
            self.emit(eventName: "addFriend", params: User(from: data["user"]))
        } else if data["status"] == "login" {
            if let exists: Bool = self.emit(eventName: "hasFriend", params: data["user"]["clientID"].uIntValue),
               exists {
                /// 更新好友在线状态并回应自己的客户端ID.
                self.emit(eventName: "addFriend", params: User(from: data["user"]))
                self.unicast([
                    "action": "connect",
                    "status": "ack",
                    "user": [
                        /// 只发送客户端ID以减小网络开销.
                        "clientID": self.user!.clientID
                    ],
                    "version": version
                ], to: data["user"]["clientID"].uIntValue)
            } else {
                /// 请求好友的详细信息并回应自己的完整用户信息.
                self.unicast([
                    "action": "connect",
                    "status": "request",
                    "version": version
                ], to: data["user"]["clientID"].uIntValue)
                self.unicast([
                    "action": "connect",
                    "status": "ack",
                    "user": self.user!.toJSON(),
                    "version": version
                ], to: data["user"]["clientID"].uIntValue)
            }
        } else if data["status"] == "logout" {
            /// 标记好友离线.
            self.emit(eventName: "offlineFriend", params: data["user"]["clientID"].uIntValue)
        } else if data["status"] == "request" {
            /// 收到好友对详细信息的请求回应自己的完整用户信息.
            self.unicast([
                "action": "connect",
                "status": "ack",
                "user": self.user!.toJSON(),
                "version": version
            ], to: data["user"]["clientID"].uIntValue)
        }
    }

    /// 处理WebSocket服务器操作类型为`player`的消息, `player`操作用于同步视频播放状态, 包括控制视频的播放/暂停, 修改播放进度和调整播放速率.
    ///
    /// - Parameters:
    ///   - data: 收到的数据.
    private func handlePlayerAction(_ data: JSON) {
        /// 同步播放器状态并打开播放器模态框.
        self.emit(eventName: "receivePlayerSync", params: data["command"])
        self.emit(eventName: "openModal", params: (data["command"], data["user"]["clientID"].uIntValue))
    }

    /// 将收到的WebSocket消息分发处理(订阅`messagePublisher`).
    private func handleWebSocketMessage() {
        messagePublisher
            /// 将收到的消息根据操作类型进行分发.
            .sink(receiveValue: { message in
                switch message {
                case .string(let string):
                    let data = JSON(string.data(using: .utf8)!)["data"]

                    switch data["action"] {
                    case "chat":
                        self.handleChatAction(data)
                    case "connect":
                        self.handleConnectAction(data)
                    case "player":
                        self.handlePlayerAction(data)
                    default:
                        break
                    }
                default:
                    break
                }
            })

            /// 将消息事件发布者保存到取消器集合中.
            .store(in: &cancellables)
    }

    /// 接收来自WebSocket服务器的消息(使用`messagePublisher`发布结果).
    private func receiveMessage() {
        guard let socket = socket
        else {
            print("尚未建立WebSocket连接; 或WebSocket连接已断开不再继续处理消息.")
            return
        }

        socket.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                self.messagePublisher.send(message)
                self.receiveMessage()
            case .failure(let error):
                print("接收消息失败: \(error.localizedDescription)")
            }
        })
    }

    /// 向WebSocket服务器连接的指定客户端单播数据.
    ///
    /// - Parameters:
    ///   - data: 单播的数据.
    ///   - receivedClientID: 接收单播的客户端ID.
    ///
    /// - Important:
    ///   调用该方法前请确保WebSocket连接已建立, 否则会导致程序崩溃.
    private func unicast(_ data: JSON, to receivedClientID: UInt) {
        guard let socket = socket
        else {
            fatalError("尚未建立WebSocket连接!")
        }

        let json = JSON([
            "props": [
                "type": "websocket.unicast",
                "receivedClientID": receivedClientID
            ],
            "data": data
        ])

        guard let rawString = json.rawString()
        else {
            fatalError("无法将JSON数据转换成字符串!")
        }

        let message = URLSessionWebSocketTask.Message.string(rawString)
        socket.send(message, completionHandler: { error in
            if let error = error {
                print("向客户端\(receivedClientID)单播消息失败: \(error.localizedDescription)")
            }
        })
    }
}
