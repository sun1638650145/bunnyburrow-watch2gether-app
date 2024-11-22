//
//  FriendsList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/21.
//

import SwiftUI

struct FriendsList: View {
    @Environment(FriendsViewModel.self) var friendsViewModel

    var body: some View {
        VStack(alignment: .leading, content: {
            Text("在线好友: \(friendsViewModel.getFriendsList().count)")
                .foregroundStyle(Color(hex: "#F9F9F9"))
                .frame(height: 22)
                .padding(10)
            
            ScrollView(.horizontal, content: {
                HStack {
                    ForEach(friendsViewModel.getFriendsList(), content: { friend in
                        VStack {
                            if let avatar = friend.avatar {
                                Image(base64: avatar)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                            } else {
                                Circle()
                                    .foregroundStyle(Color.white)
                                    .frame(width: 50, height: 50)
                            }
                            
                            // TODO: 暂未添加用户昵称动画(Steve).
                            Text(friend.name)
                                .font(.footnote)
                                .foregroundStyle(Color(hex: "#F9F9F9"))
                                .frame(maxWidth: 60)
                                .lineLimit(1)
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
    
    FriendsList()
        .environment(friendsViewModel)
}
