//
//  User.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import Foundation
import SwiftUI

/// 用户信息.
struct User: Identifiable {
    /// 头像的Base-64.
    let avatar: String?
    
    /// 客户端ID.
    let clientID: UInt
    
    /// 昵称.
    let name: String
    
    /// 遵循`Identifiable`协议要求.
    var id: UInt {
        return clientID
    }
    
    init(_ avatar: PlatformImage? = nil, _ name: String) {
        self.avatar = Image.convertToBase64(platformImage: avatar)
        // TODO: 目前使用时间戳生成, 未来改进为使用UUID; 同时兼容Web客户端的实现(Steve).
        self.clientID = UInt(Date().timeIntervalSince1970 * 1000)
        self.name = name
    }
}
