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
        // ...
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
}
