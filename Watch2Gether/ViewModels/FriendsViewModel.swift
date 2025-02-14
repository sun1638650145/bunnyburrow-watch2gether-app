//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  FriendsViewModel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/22.
//

import Observation

import OrderedCollections

/// 好友信息视图模型.
@Observable
class FriendsViewModel {
    /// 好友信息字典, 键为客户端ID, 值为好友信息结构体.
    private var friends: OrderedDictionary<UInt, Friend> = [:]

    /// 向字典添加好友(或更新在线状态).
    ///
    /// - Parameters:
    ///   - friend: 好友用户信息.
    func addFriend(friend: User) {
        if let existingFriend = self.friends[friend.clientID] {
            existingFriend.updateOnlineStatus(to: true)

            /// 移除好友, 可以使得好友添加字典到末尾.
            self.friends.removeValue(forKey: friend.clientID)
            self.friends[friend.clientID] = existingFriend
        } else {
            self.friends[friend.clientID] = Friend(friend.avatar, friend.name, onlineStatus: true)
        }
    }

    /// 获取在线好友列表.
    ///
    /// - Returns: 包含所有在线好友的`User`数组.
    func getOnlineFriendsList() -> [User] {
        return self.friends
            /// 筛选在线好友.
            .filter({ _, friend in friend.onlineStatus })
            .map({ clientID, friend in User(avatar: friend.avatar, clientID: clientID, name: friend.name) })
    }

    /// 将字典中所有的好友标记为离线.
    func offlineAllFriends() {
        /// 不需要使自己离线.
        for (index, clientID) in self.friends.keys.enumerated() where index != 0 {
            self.offlineFriend(by: clientID)
        }
    }

    /// 从字典中标记指定客户端ID的好友为离线.
    ///
    /// - Parameters:
    ///   - clientID: 好友的客户端ID.
    func offlineFriend(by clientID: UInt) {
        if let friend = self.friends[clientID] {
            friend.updateOnlineStatus(to: false)

            /// `OrderedDictionary`结构体是值类型, 需要显式重新赋值.
            self.friends[clientID] = friend
        }
    }

    /// 根据客户端ID搜索好友信息.
    ///
    /// - Parameters:
    ///   - clientID: 好友的客户端ID.
    /// - Returns: 如果找到则返回对应的好友信息`User`实例, 否则返回`nil`.
    func searchFriend(by clientID: UInt) -> User? {
        guard let friend = self.friends[clientID]
        else {
            return nil
        }

        return User(avatar: friend.avatar, clientID: clientID, name: friend.name)
    }
}
