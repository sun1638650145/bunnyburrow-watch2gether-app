//
//  MessagesList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/29.
//

import SwiftUI

struct MessagesList: View {
    @Environment(User.self) var user
    
    /// 聊天消息列表变量.
    var messages: [Message]
    
    var body: some View {
        List(messages.indices, id: \.self, rowContent: { index in
            if messages[index].clientID == user.clientID {
                MyMessage(content: messages[index].content, avatar: user.avatar)
            } else {
                Text(messages[index].content)
                    .listRowBackground(Color(hex: "#1A1D29"))
                    .listRowSeparator(.hidden)
            }
        })
        .listStyle(PlainListStyle())
    }
}

#Preview {
    let user = User(
        avatar: "/9j/2wCEAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ" +
                "0Hyc5PTgyPC4zNDIBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj" +
                "IyMjIyMjIyMjIyMjIyMjIyMv/AABEIABkAGQMBIgACEQEDEQH/xAGiAAABBQEBAQEBAQAAAAAAAAAAA" +
                "QIDBAUGBwgJCgsQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHw" +
                "JDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4S" +
                "FhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6O" +
                "nq8fLz9PX29/j5+gEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoLEQACAQIEBAMEBwUEBAABAncAA" +
                "QIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RF" +
                "RkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S" +
                "1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/ANOe/C" +
                "2unyKSWIRm/Sti51KRoljyEUx4IPU965C7vXtI7TaoYJChAI9hWlq+o239t29o8jR3E8RljUKcbQDk5" +
                "/4CePeso7ls5fxFdebAjZ6k/wA65nc3qa1dUE95uSGNnbeSFUZOMZ6fhWDlvU0pS1GkemSR3V6oj8qP" +
                "5l2IrJux6cjB/DNchr+t61pWuR2k7Wz3NsqxwTCHGFdR2yexH5VufD37/wCf9K5Pxd/yOi/7y/0q8NL" +
                "3mrGddOydzd1CO9NgYJJjgYJ2qE3c55A6/jXOf2fL/kCu41T/AI9pfoP6Vk1k97lps//Z",
        clientID: 2023,
        name: "Steve"
    )
    let messages = [
        Message(content: "你好", clientID: 2023),
        Message(content: "Hi!", clientID: 2024)
    ]
    
    MessagesList(messages: messages)
        .environment(user)
}
