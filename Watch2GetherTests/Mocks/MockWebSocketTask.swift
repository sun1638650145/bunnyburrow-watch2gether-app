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
    func cancel() {
        // ...
    }

    func receive(completionHandler: @escaping @Sendable (Result<URLSessionWebSocketTask.Message, any Error>) -> Void) {
        // ...
    }

    func resume() {
        // ...
    }

    func send(
        _ message: URLSessionWebSocketTask.Message,
        completionHandler: @escaping @Sendable ((any Error)?) -> Void
    ) {
        // ...
    }
}
