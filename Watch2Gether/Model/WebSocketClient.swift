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
    /// 当前的WebSocket任务.
    private var socket: URLSessionWebSocketTask?
    
    /// 用户信息.
    private var user: User?
    
    /// 事件发布者字典, 键为事件名称, 值为`PassthroughSubject`.
    private var eventPublishers: [String: PassthroughSubject<Any, Never>] = [:]
    
    /// 用于存储事件监听器的取消器集合.
    private var cancellables = Set<AnyCancellable>()
    
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
        socket.send(message) { error in
            if let error = error {
                print("广播消息失败: \(error.localizedDescription)")
            }
        }
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
        self.user = user
        
        /// WebSocket连接成功后, 自动向服务器发送登录用户的信息.
        self.socket?.resume()
        self.broadcast([
            "action": "connect",
            "status": "login",
            "user": user.toJSON()
        ])
        
        self.receiveMessage()
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
            ]
        ])
        
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
    
    /// 添加包含两个参数的事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - listener: 回调函数.
    func on<T, U>(eventName: String, listener: @escaping (T, U) -> Void) {
        let publisher = PassthroughSubject<Any, Never>()
        
        publisher
            /// 确保数据类型和回调函数的期望类型一致.
            .compactMap({ $0 as? (T, U) })
            
            /// 将收到的数据传递给回调函数.
            .sink(receiveValue: { listener($0.0, $0.1) })
            
            /// 将事件监听器保存到取消器集合中.
            .store(in: &cancellables)
        
        eventPublishers[eventName] = publisher
    }
    
    /// 触发事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - param: 传递给回调函数的参数.
    private func emit<T>(eventName: String, param: T) {
        guard let publisher = self.eventPublishers[eventName]
        else {
            return
        }
        
        /// 通过发布者发送参数.
        publisher.send(param)
    }
    
    /// 触发包含两个参数的事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - param0: 传递给回调函数的第一个参数.
    ///   - param1: 传递给回调函数的第二个参数.
    private func emit<T, U>(eventName: String, param0: T, param1: U) {
        guard let publisher = self.eventPublishers[eventName]
        else {
            return
        }
        
        /// 通过发布者发送参数.
        publisher.send((param0, param1))
    }
    
    /// 处理WebSocket服务器的消息.
    ///
    /// - Important:
    ///   调用该方法前请确保WebSocket连接已建立, 否则会导致程序崩溃.
    private func receiveMessage() {
        guard let socket = socket
        else {
            fatalError("尚未建立WebSocket连接!")
        }
        
        socket.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let string):
                    let data = JSON(string.data(using: .utf8)!)["data"]
                    
                    switch data["action"] {
                    case "chat":
                        /// 接收聊天消息.
                        self.emit(
                            eventName: "receiveMessage",
                            param0: data["message"].stringValue,
                            param1: data["user"]["clientID"].uIntValue
                        )
                    case "connect":
                        if data["status"] == "ack" {
                            /// 添加好友.
                            self.emit(eventName: "addFriend", param: User(from: data["user"]))
                        } else if data["status"] == "login" {
                            /// 添加好友并同时回应自己的用户信息.
                            self.emit(eventName: "addFriend", param: User(from: data["user"]))
                            self.unicast([
                                "action": "connect",
                                "status": "ack",
                                "user": self.user!.toJSON()
                            ], to: data["user"]["clientID"].uIntValue)
                        } else if data["status"] == "logout" {
                            /// 使好友离线.
                            self.emit(
                                eventName: "offlineFriend",
                                param: data["user"]["clientID"].uIntValue
                            )
                        }
                    case "player":
                        /// 接收播放器状态同步.
                        self.emit(eventName: "receivePlayerSync", param: data["command"])
                    default:
                        break
                    }
                default:
                    break
                }
            case .failure(let error):
                print("接收消息失败:\(error.localizedDescription)")
            }
            
            self.receiveMessage()
        }
    }
    
    /// 向WebSocket服务器连接的指定客户端单播数据.
    ///
    /// - Parameters:
    ///   - data: 单播的数据.
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
        socket.send(message) { error in
            if let error = error {
                print("向客户端\(receivedClientID)单播消息失败: \(error.localizedDescription)")
            }
        }
    }
}
