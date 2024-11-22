//
//  FriendsList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/21.
//

import SwiftUI

struct FriendsList: View {
    @Environment(FriendsManager.self) var friendsManager

    var body: some View {
        VStack(alignment: .leading, content: {
            Text("在线好友: \(friendsManager.friends.count)")
                .foregroundStyle(Color(hex: "#F9F9F9"))
                .frame(height: 22)
                .padding(10)
            
            ScrollView(.horizontal, content: {
                HStack {
                    ForEach(Array(friendsManager.friends.keys), id: \.self, content: { key in
                        let (avatar, name) = friendsManager.friends[key]!
                        
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
