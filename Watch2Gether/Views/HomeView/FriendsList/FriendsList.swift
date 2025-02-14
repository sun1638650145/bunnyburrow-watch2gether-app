//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  FriendsList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/21.
//

import SwiftUI

/// `FriendsList`是用于显示在线好友列表的视图.
struct FriendsList: View {
    @Environment(FriendsViewModel.self) var friendsViewModel

    /// 在线好友列表.
    private var onlineFriends: [User] {
        return friendsViewModel.getOnlineFriendsList()
    }

    var body: some View {
        VStack(alignment: .leading, content: {
            Text("在线好友: \(onlineFriends.count)")
                .foregroundStyle(Color.foreground)
                .frame(height: 22)
                .padding(10)

            ScrollView(.horizontal, content: {
                HStack {
                    ForEach(onlineFriends, content: { friend in
                        VStack {
                            Image(base64: friend.avatar ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .overlay(content: {
                                    Circle().stroke(Color.avatarBorder, lineWidth: 2)
                                })

                            MarqueeText(friend.name, duration: 6.0, color: .foreground, font: .footnote)
                        }
                        .frame(width: 60, height: 80)
                    })
                }
            })
            .padding(.leading, 10)
        })
    }
}

#Preview {
    let user0 = User(
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
        name: "Steve R. Sun"
    )
    let user1 = User(avatar: nil, clientID: 2025, name: "A")

    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()

        friendsViewModel.addFriend(friend: user0)
        friendsViewModel.addFriend(friend: user1)

        return friendsViewModel
    }

    FriendsList()
        .environment(friendsViewModel)
}
