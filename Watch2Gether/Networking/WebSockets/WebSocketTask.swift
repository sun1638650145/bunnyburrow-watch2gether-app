//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  WebSocketTask.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2026/3/8.
//

import Foundation

/// WebSocket任务协议, 该协议定义了WebSocket连接中最基本的任务行为.
protocol WebSocketTask {
    /// 取消任务.
    func cancel()

    /// 当消息的所有帧都可用时, 读取一条WebSocket消息.
    ///
    /// - Parameters:
    ///   - completionHandler: 接收两个参数的闭包: WebSocket消息和一个`NSError`对象, 该`NSError`表示在接收消息时遇到的错误.
    func receive(completionHandler: @escaping @Sendable (Result<URLSessionWebSocketTask.Message, any Error>) -> Void)

    /// 如果任务处于暂停状态, 则恢复该任务.
    func resume()

    /// 发送一条WebSocket消息, 并在完成回调函数中接收结果.
    ///
    /// - Parameters:
    ///   - message: 要发送到另一端的WebSocket消息.
    ///   - completionHandler: 接收一个`NSError`对象的闭包, 该`NSError`表示在发送过程中遇到的错误.
    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping @Sendable ((any Error)?) -> Void)
}
