//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  MockWebSocketTask.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/10.
//

import Foundation

@testable import Watch2Gether

/// 用于测试的`WebSocketTask`, 拦截WebSocket连接中的任务并返回模拟的数据.
class MockWebSocketTask: WebSocketTask {
    /// 记录最近一次调用`receive(completionHandler:)`时传入的闭包.
    private var completionHandler: ((Result<URLSessionWebSocketTask.Message, any Error>) -> Void)?

    /// 记录`cancel()`被调用的次数.
    private(set) var cancelCallCount: Int = 0

    /// 记录`resume()`被调用的次数.
    private(set) var resumeCallCount: Int = 0

    /// 通过`send(_:completionHandler:)`发送的所有WebSocket消息.
    private(set) var messages: [URLSessionWebSocketTask.Message] = []

    func cancel() {
        self.cancelCallCount += 1
    }

    func receive(completionHandler: @escaping @Sendable (Result<URLSessionWebSocketTask.Message, any Error>) -> Void) {
        self.completionHandler = completionHandler
    }

    func resume() {
        self.resumeCallCount += 1
    }

    func send(
        _ message: URLSessionWebSocketTask.Message,
        completionHandler: @escaping @Sendable ((any Error)?) -> Void
    ) {
        self.messages.append(message)
    }

    /// 模拟系统收到一条WebSocket消息并触发闭包, 便于进行测试.
    ///
    /// - Parameters:
    ///   - message: 模拟系统收到的WebSocket消息.
    func simulateSystemIncomingMessage(_ message: URLSessionWebSocketTask.Message) {
        /// 读取并清空闭包, 保证一次`receive(completionHandler:)`只触发一次, 避免竞态条件(race condition).
        let completionHandler = self.completionHandler
        self.completionHandler = nil

        completionHandler?(.success(message))
    }
}
