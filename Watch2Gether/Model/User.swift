//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  User.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import Foundation
import Observation

import SwiftyJSON

/// 用户信息.
@Observable
class User: Identifiable {
    /// 头像的Base-64.
    var avatar: String?

    /// 客户端ID.
    let clientID: UInt

    /// 昵称.
    var name: String

    /// 遵循`Identifiable`协议要求.
    var id: UInt {
        return clientID
    }

    init(avatar: String? = nil, clientID: UInt, name: String) {
        self.avatar = avatar
        self.clientID = clientID
        self.name = name
    }

    convenience init() {
        // TODO: 目前使用时间戳生成, 未来改进为使用UUID; 同时兼容Web客户端的实现(Steve).
        let clientID = UInt(Date().timeIntervalSince1970 * 1000)
        let name = "User-\(clientID)"

        self.init(clientID: clientID, name: name)
    }

    convenience init(from json: JSON) {
        let avatar = json["avatar"].string
        let clientID = json["clientID"].uIntValue
        let name = json["name"].stringValue

        self.init(avatar: avatar, clientID: clientID, name: name)
    }

    /// 更新用户信息.
    ///
    /// - Parameters:
    ///   - newAvatar: 新的头像的Base-64.
    ///   - newName: 新的昵称.
    func update(_ newAvatar: String? = nil, _ newName: String) {
        self.avatar = newAvatar
        self.name = newName
    }
}
