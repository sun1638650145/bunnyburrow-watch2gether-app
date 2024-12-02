//
//  MessagesList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/29.
//

import SwiftUI

struct MessagesList: View {
    @Environment(User.self) var user
    @Environment(FriendsViewModel.self) var friendsViewModel
    
    /// 聊天消息列表变量.
    var messages: [Message]
    
    var body: some View {
        ScrollViewReader { proxy in
            List(messages.indices, id: \.self, rowContent: { index in
                let message = messages[index]
                let friend = friendsViewModel.searchFriend(by: message.clientID)!
                
                if friend.clientID == user.clientID {
                    MyMessage(content: message.content, avatar: user.avatar)
                } else {
                    OtherMessage(content: message.content, avatar: friend.avatar, name: friend.name)
                }
            })
            .listStyle(PlainListStyle())
            .onChange(of: messages.count, {
                withAnimation(.linear, {
                    if let last = messages.indices.last {
                        /// 当有新聊天消息时, 始终将消息流保持在底部.
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                })
            })
            .scrollIndicators(.hidden)
            #if os(macOS)
            /// 在macOS上隐藏列表内可滚动视图的背景.
            .scrollContentBackground(.hidden)
            #endif
        }
    }
}

#Preview {
    let user0 = User(
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
    let user1 = User(avatar: nil, clientID: 2024, name: "A")
    
    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()
        
        friendsViewModel.addFriend(friend: user0)
        friendsViewModel.addFriend(friend: user1)
        
        return friendsViewModel
    }
    
    let messages = [
        Message(content: "你好", clientID: 2023),
        Message(content: "Hi!", clientID: 2024)
    ]
    
    MessagesList(messages: messages)
        .environment(user0)
        .environment(friendsViewModel)
}
