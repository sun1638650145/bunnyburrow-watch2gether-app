//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  WebSocketClientProtocol.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2026/3/7.
//

import SwiftyJSON

/// WebSocket客户端协议, 该协议定义了WebSocket客户端的核心能力.
protocol WebSocketClientProtocol {
    /// 用户信息.
    var user: User? { get }

    /// 向WebSocket服务器广播数据.
    ///
    /// - Parameters:
    ///   - data: 广播的数据.
    ///
    /// - Important:
    ///   调用该方法前请确保WebSocket连接已建立, 否则会导致程序崩溃.
    func broadcast(_ data: JSON)

    /// 建立WebSocket连接.
    ///
    /// - Parameters:
    ///   - url: WebSocket服务地址.
    ///   - user: 用户信息.
    func connect(_ url: String, _ user: User)

    /// 断开与WebSocket服务器的连接.
    func disconnect()

    /// 添加事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - listener: 回调函数.
    func on<T>(eventName: String, listener: @escaping (T) -> Void)

    /// 添加携带返回值的事件监听器.
    ///
    /// - Parameters:
    ///   - eventName: 事件名称.
    ///   - listener: 携带返回值的回调函数.
    func on<T, U>(eventName: String, listener: @escaping (T) -> U)

    /// 重新建立WebSocket连接.
    func reconnect()
}
