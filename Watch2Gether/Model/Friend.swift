//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Friend.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/26.
//

/// 好友信息.
class Friend {
    /// 头像的Base-64.
    let avatar: String?

    /// 昵称.
    let name: String

    /// 在线状态.
    var onlineStatus: Bool

    init(_ avatar: String?, _ name: String, onlineStatus: Bool) {
        self.avatar = avatar
        self.name = name
        self.onlineStatus = onlineStatus
    }

    /// 更新在线状态.
    ///
    /// - Parameters:
    ///   - status: 新的在线状态.
    func updateOnlineStatus(to status: Bool) {
        self.onlineStatus = status
    }
}
