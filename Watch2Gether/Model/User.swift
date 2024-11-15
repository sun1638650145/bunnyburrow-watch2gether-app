//
//  User.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import Foundation
import Observation

/// 用户信息.
@Observable
class User: Identifiable {
    /// 头像的Base-64.
    var avatar: String?
    
    /// 客户端ID.
    var clientID: UInt
    
    /// 昵称.
    var name: String
    
    /// 遵循`Identifiable`协议要求.
    var id: UInt {
        return clientID
    }
    
    init(_ avatar: String? = nil, _ name: String) {
        self.avatar = avatar
        // TODO: 目前使用时间戳生成, 未来改进为使用UUID; 同时兼容Web客户端的实现(Steve).
        self.clientID = UInt(Date().timeIntervalSince1970 * 1000)
        self.name = name
    }
}
