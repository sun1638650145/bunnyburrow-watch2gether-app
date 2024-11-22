//
//  FriendsManager.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/22.
//

import Observation

/// 好友信息管理器.
@Observable
class FriendsManager {
    /// 好友信息字典, 键为客户端ID, 值为头像的Base-64和昵称组成的元组.
    var friends: Dictionary<UInt, (String?, String)> = [:]
    
    /// 向好友字典添加好友.
    ///
    /// - Parameters:
    ///   - friend: 好友用户信息.
    func addFriend(friend: User) {
        self.friends[friend.clientID] = (friend.avatar, friend.name)
    }
    
    /// 从字典中移除指定客户端ID的好友.
    ///
    /// - Parameters:
    ///   - clientID: 好友的客户端ID.
    func removeFriend(by clientID: UInt) {
        self.friends.removeValue(forKey: clientID)
    }
}
