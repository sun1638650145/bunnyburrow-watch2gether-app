//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  WebSocketClientExtension.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/4/19.
//

import SwiftyJSON

extension WebSocketClient {
    /// 发送播放器状态同步命令.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    func sendPlayerSync(command: JSON) {
        self.broadcast([
            "action": "player",
            "command": command,
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": self.user!.clientID
            ]
        ])
    }
}
