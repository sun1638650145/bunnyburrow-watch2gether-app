//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MessageStoreViewModel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/24.
//

import Observation

/// 用于存储聊天消息的视图模型.
@Observable
class MessageStoreViewModel {
    /// 存储的聊天消息列表.
    var messages: [Message] = []

    /// 向列表中添加聊天消息.
    ///
    /// - Parameters:
    ///   - message: 聊天消息.
    func addMessage(message: Message) {
        messages.append(message)
    }
}
