//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  UserTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/4.
//

import Testing

import SwiftyJSON

@testable import Watch2Gether

struct UserTests {
    @Test
    func convertUserToJSON() {
        let user = User(clientID: 2026, name: "Steve")

        let json = user.toJSON()

        #expect(json["avatar"].string == user.avatar ?? "")
        #expect(json["clientID"].uIntValue == user.clientID)
        #expect(json["name"].stringValue == user.name)
    }

    @Test
    func initializeUserFromJSON() {
        let json = JSON(["avatar": nil, "clientID": 2026, "name": "Steve"])
        let user = User(from: json)

        #expect(user.avatar == json["avatar"].string)
        #expect(user.clientID == json["clientID"].uIntValue)
        #expect(user.name == json["name"].stringValue)
        #expect(user.id == user.clientID)
    }

    @Test
    func updateUserProfile() {
        let user = User(clientID: 2025, name: "A")

        user.update("base64", "Steve")

        #expect(user.avatar == "base64")
        #expect(user.clientID == 2025, "更新用户信息后不会修改客户端ID.")
        #expect(user.name == "Steve")
    }
}
