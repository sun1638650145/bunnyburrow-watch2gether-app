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
    var socket: URLSessionWebSocketTask?
    
    /// 用户信息.
    var user: User?
    
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
}
