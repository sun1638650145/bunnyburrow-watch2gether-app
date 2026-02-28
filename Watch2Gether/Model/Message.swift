//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  Message.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/29.
//

import Foundation

/// 聊天消息.
struct Message: Equatable, Identifiable {
    /// 聊天消息的内容.
    var content: String

    /// 消息所属的客户端ID.
    var clientID: UInt

    /// 遵循`Identifiable`协议要求.
    var id: UUID = UUID()

    /// 遵循`Equatable`协议要求.
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}
