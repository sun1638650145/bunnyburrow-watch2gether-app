//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  URLSessionWebSocketTask.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2026/3/8.
//

import Foundation

/// 让`URLSessionWebSocketTask`遵循`WebSocketTaskProtocol`协议, 便于进行测试.
extension URLSessionWebSocketTask: WebSocketTaskProtocol {}
