//
//  FriendsViewModel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/22.
//

import Observation

/// 好友信息视图模型.
@Observable
class FriendsViewModel {
    /// 好友信息字典, 键为客户端ID, 值为头像的Base-64和昵称组成的元组.
    private var friends: Dictionary<UInt, (String?, String)> = [:]
    
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
    
    /// 获取好友列表.
    ///
    /// - Returns: 包含所有好友的`User`数组.
    func getFriendsList() -> [User] {
        return self.friends.map({ key, value in
            User(avatar: value.0, clientID: key, name: value.1)
        })
    }
}
