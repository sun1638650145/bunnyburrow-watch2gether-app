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

    /// 配置WebSocket连接.
    ///
    /// - Parameters:
    ///   - url: WebSocket服务地址.
    ///   - user: 用户信息.
    ///   - friendsViewModel: 好友信息视图模型.
    func setupConnection(_ url: String, _ user: User, with friendsViewModel: FriendsViewModel) {
        self.connect(url, user)

        self.on(eventName: "addFriend", listener: friendsViewModel.addFriend(friend:))
        self.on(eventName: "hasFriend", listener: { (clientID: UInt) -> Bool in
            return friendsViewModel.searchFriend(by: clientID) != nil
        })
        self.on(eventName: "offlineAllFriends", listener: friendsViewModel.offlineAllFriends)
        self.on(eventName: "offlineFriend", listener: friendsViewModel.offlineFriend(by:))
    }
}
