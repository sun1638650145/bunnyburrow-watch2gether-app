//
//  WebSocketClient.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/19.
//

import Foundation
import Observation

/// WebSocket客户端.
@Observable
class WebSocketClient {
    /// 当前的WebSocket任务.
    var socket: URLSessionWebSocketTask?
    
    /// 建立WebSocket连接.
    ///
    /// - Parameters:
    ///   - url: WebSocket服务地址.
    ///   - user: 用户信息.
    func connect(_ url: String, _ user: User) {
        let session = URLSession(configuration: .default)
        
        /// 使用专属的WebSocket服务地址.
        self.socket = session.webSocketTask(with: URL(string: url + String(user.clientID) + "/")!)
        self.socket?.resume()
    }
}
