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
    /// 好友信息字典, 键为客户端ID, 值为头像的Base-64, 昵称和是否在线组成的元组.
    private var friends: OrderedDictionary<UInt, (String?, String, Bool)> = [:]
    
    /// 向好友字典添加好友.
    ///
    /// - Parameters:
    ///   - friend: 好友用户信息.
    func addFriend(friend: User) {
        self.friends[friend.clientID] = (friend.avatar, friend.name, true)
    }
        
    /// 获取在线好友列表.
    ///
    /// - Returns: 包含所有在线好友的`User`数组.
    func getOnlineFriendsList() -> [User] {
        return self.friends
            /// 筛选在线好友.
            .filter({ _, value in value.2 == true })
            .map({ key, value in User(avatar: value.0, clientID: key, name: value.1)})
    }
    
    /// 从字典中标记指定客户端ID的好友为离线.
    ///
    /// - Parameters:
    ///   - clientID: 好友的客户端ID.
    func offlineFriend(by clientID: UInt) {
        if var friend = self.friends[clientID] {
            friend.2 = false
            self.friends[clientID] = friend
        }
    }
    
    /// 根据客户端ID搜索好友信息.
    ///
    /// - Parameters:
    ///   - clientID: 要搜索的好友客户端ID.
    /// - Returns: 如果找到则返回对应的好友信息`User`实例, 否则返回`nil`.
    func searchFriend(by clientID: UInt) -> User? {
        guard let value = self.friends[clientID]
        else {
            return nil
        }
        
        return User(avatar: value.0, clientID: clientID, name: value.1)
    }
}
