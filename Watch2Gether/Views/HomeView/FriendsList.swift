//
//  FriendsList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/21.
//

import SwiftUI

struct FriendsList: View {
    /// 好友信息字典, 键为客户端ID, 值为头像的Base-64和昵称组成的元组.
    var friends: Dictionary<UInt, (String?, String)>

    var body: some View {
        VStack(alignment: .leading, content: {
            Text("在线好友: \(friends.count)")
                .foregroundStyle(Color(hex: "#F9F9F9"))
                .frame(height: 22)
                .padding(10)
            
            ScrollView(.horizontal, content: {
                HStack {
                    ForEach(Array(friends.keys), id: \.self, content: { key in
                        let (avatar, name) = friends[key]!
                        
                        VStack {
                            if let avatar = avatar {
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
                            Text(name)
                                .font(.footnote)
                                .foregroundStyle(Color(hex: "#F9F9F9"))
                                .frame(maxWidth: 60)
                                .lineLimit(1)
                        }
                        .frame(width: 60)
                    })
                }
            })
            .padding(.leading, 10)
        })
    }
}

#Preview {
    let friends: Dictionary<UInt, (String?, String)> = [
        2023: ("/9j/2wCEAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0" +
               "Hyc5PTgyPC4zNDIBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy" +
               "MjIyMjIyMjIyMjIyMjIyMv/AABEIABkAGQMBIgACEQEDEQH/xAGiAAABBQEBAQEBAQAAAAAAAAAAAQID" +
               "BAUGBwgJCgsQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNi" +
               "coIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeI" +
               "iYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz" +
               "9PX29/j5+gEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoLEQACAQIEBAMEBwUEBAABAncAAQIDEQQF" +
               "ITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpT" +
               "VFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrC" +
               "w8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/ANOe/C2unyKSWIRm" +
               "/Sti51KRoljyEUx4IPU965C7vXtI7TaoYJChAI9hWlq+o239t29o8jR3E8RljUKcbQDk5/4CePeso7ls" +
               "5fxFdebAjZ6k/wA65nc3qa1dUE95uSGNnbeSFUZOMZ6fhWDlvU0pS1GkemSR3V6oj8qP5l2IrJux6cjB" +
               "/DNchr+t61pWuR2k7Wz3NsqxwTCHGFdR2yexH5VufD37/wCf9K5Pxd/yOi/7y/0q8NL3mrGddOydzd1C" +
               "O9NgYJJjgYJ2qE3c55A6/jXOf2fL/kCu41T/AI9pfoP6Vk1k97lps//Z", "Steve"),
        2024: (nil, "A"),
    ]
    
    FriendsList(friends: friends)
}
