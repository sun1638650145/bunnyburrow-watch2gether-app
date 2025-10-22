//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  WelcomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/10/22.
//

import SwiftUI

/// `WelcomeView`是快速登录视图, 当用户信息存在时, 用户可直接进入主界面.
struct WelcomeView: View {
    @Environment(User.self) var user

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.foreground)
                    .padding(20)
            }

            Spacer()
        }

        VStack {
            Text("Welcome back, \(user.name)!")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color.foreground)

            Image(base64: user.avatar ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .glassEffectCompat()
        }

        VStack {
            Spacer()

            Text("Copyright © 2025 Steve R. Sun")
                .copyright()
        }
    }
}

#Preview {
    let user = User(
        avatar: "/9j/2wCEAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDIBCQk" +
                "JDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIABkAGQMBIg" +
                "ACEQEDEQH/xAGiAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgsQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcic" +
                "RQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SF" +
                "hoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+gEAAwE" +
                "BAQEBAQEBAQAAAAAAAAECAwQFBgcICQoLEQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8B" +
                "VictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYm" +
                "Zqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/ANOe/C2u" +
                "nyKSWIRm/Sti51KRoljyEUx4IPU965C7vXtI7TaoYJChAI9hWlq+o239t29o8jR3E8RljUKcbQDk5/4CePeso7ls5fxFdebAjZ6" +
                "k/wA65nc3qa1dUE95uSGNnbeSFUZOMZ6fhWDlvU0pS1GkemSR3V6oj8qP5l2IrJux6cjB/DNchr+t61pWuR2k7Wz3NsqxwTCHGF" +
                "dR2yexH5VufD37/wCf9K5Pxd/yOi/7y/0q8NL3mrGddOydzd1CO9NgYJJjgYJ2qE3c55A6/jXOf2fL/kCu41T/AI9pfoP6Vk1k9" +
                "7lps//Z",
        clientID: 2025,
        name: "Steve"
    )

    ZStack {
        Color.background
            .ignoresSafeArea()

        WelcomeView()
            .environment(user)
    }
}
