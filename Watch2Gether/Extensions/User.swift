//
//  User.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/19.
//

import SwiftyJSON

extension User {
    /// 转换成`JSON`格式.
    ///
    /// - Returns: 表示用户信息的`JSON`对象.
    func toJSON() -> JSON {
        return JSON([
            "avatar": self.avatar ?? "",
            "clientID": self.clientID,
            "name": self.name
        ])
    }
}
