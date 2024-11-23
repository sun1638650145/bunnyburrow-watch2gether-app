//
//  WebSocketClient.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/19.
//

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
    
    /// 事件监听函数字典, 键为事件名称, 值为回调函数.
    private var eventListeners: [String: (Any) -> Void] = [:]
    
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
                "clientID": self.user?.clientID
            ]
        ])
        
        socket.cancel()
        self.socket = nil
    }
    
    /// 添加事件监听函数.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - listener: 回调函数.
    func on<T>(eventName: String, listener: @escaping (T) -> Void) {
        self.eventListeners[eventName] = { params in
            if let params = params as? T {
                return listener(params)
            }
        }
    }
    
    /// 触发事件监听函数.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - params: 传递给回调函数的参数.
    private func emit<T>(eventName: String, params: T) {
        guard let listener = self.eventListeners[eventName]
        else {
            return
        }
        
        listener(params)
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
                    case "connect":
                        if data["status"] == "ack" {
                            /// 添加好友.
                            // TODO: 增加User的初始化器(Steve).
                            let user = User(
                                avatar: data["user"]["avatar"].rawString(),
                                clientID: data["user"]["clientID"].uIntValue,
                                name: data["user"]["name"].rawString()!
                            )
                            self.emit(eventName: "addFriend", params: user)
                        } else if data["status"] == "login" {
                            /// 添加好友并同时回应自己的用户信息.
                            let user = User(
                                avatar: data["user"]["avatar"].rawString(),
                                clientID: data["user"]["clientID"].uIntValue,
                                name: data["user"]["name"].rawString()!
                            )
                            self.emit(eventName: "addFriend", params: user)
                        } else if data["status"] == "logout" {
                            /// 移除好友.
                            self.emit(
                                eventName: "removeFriend",
                                params: data["user"]["clientID"].uIntValue
                            )
                        }
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
}
