//
//  User.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import Foundation

/// 用户信息.
struct User: Identifiable {
    /// 头像.
    let avatar: PlatformImage?
    
    /// 客户端ID.
    let clientID: Int
    
    /// 昵称.
    let name: String
    
    /// 遵循`Identifiable`协议要求.
    var id: Int {
        return clientID
    }
    
    init(avatar: PlatformImage? = nil, name: String) {
        self.avatar = avatar
        // TODO: 目前使用时间戳生成, 未来改进为使用UUID; 同时兼容Web客户端的实现(Steve).
        self.clientID = Int(Date().timeIntervalSince1970 * 1000)
        self.name = name
    }
}
