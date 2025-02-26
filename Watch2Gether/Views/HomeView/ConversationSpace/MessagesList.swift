//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MessagesList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/29.
//

import SwiftUI

/// `MessagesList`是用于显示聊天消息列表的视图.
struct MessagesList: View {
    @Environment(User.self) var user
    @Environment(FriendsViewModel.self) var friendsViewModel

    /// 聊天消息列表变量.
    private let messages: [Message]

    init(_ messages: [Message]) {
        self.messages = messages
    }

    var body: some View {
        ScrollViewReader(content: { proxy in
            ScrollView {
                ForEach(messages.indices, id: \.self, content: { index in
                    let message = messages[index]
                    let friend = friendsViewModel.searchFriend(by: message.clientID)!

                    if friend.clientID == user.clientID {
                        MyMessageBubble(content: message.content, avatar: user.avatar)
                    } else {
                        OtherMessageBubble(content: message.content, avatar: friend.avatar, name: friend.name)
                    }
                })
            }
            .onChange(of: messages.indices, {
                if let last = messages.indices.last {
                    /// 当新的聊天消息时, 动画滚动到最新消息的位置.
                    withAnimation(.easeInOut, {
                        proxy.scrollTo(last, anchor: .bottom)
                    })
                }
            })
            .padding(.horizontal, 10)
            .scrollIndicators(.hidden)
        })
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
        clientID: 2023,
        name: "Steve"
    )
    let friend = User(avatar: nil, clientID: 2025, name: "A")

    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()

        friendsViewModel.addFriend(friend: user)
        friendsViewModel.addFriend(friend: friend)

        return friendsViewModel
    }

    let messages = [
        Message(content: "你好", clientID: 2023),
        Message(content: "Hi!", clientID: 2025)
    ]

    MessagesList(messages)
        .environment(user)
        .environment(friendsViewModel)
}
