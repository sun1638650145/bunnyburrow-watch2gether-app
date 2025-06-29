//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DanmakuSpace.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/17.
//

import SwiftUI

/// `DanmakuSpace`是用于以弹幕形式显示聊天消息的视图;
/// 它只显示在视图出现后(通常是视频播放器全屏时)收到的新聊天消息, 忽略历史消息.
struct DanmakuSpace: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(MessageStoreViewModel.self) var messageStoreViewModel

    /// 聊天消息列表变量.
    @State private var messages: [Message] = []

    /// 历史聊天消息计数, 用于忽略视图出现前的聊天消息.
    @State private var historyMessageCount: Int = 0

    /// 弹幕轨道的数量.
    private let trackCount: Int

    /// 弹幕轨道的高度.
    private let trackHeight: CGFloat

    init(trackCount: Int = 3, trackHeight: CGFloat = 58.0) {
        self.trackCount = trackCount
        self.trackHeight = trackHeight
    }

    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(messages.enumerated()), id: \.offset, content: { index, message in
                    let friend = friendsViewModel.searchFriend(by: message.clientID)!
                    /// 为当前聊天消息分配弹幕轨道.
                    let trackIndex = index % trackCount
                    
                    Button(action: {
                        appSettings.showDanmakuMessageInput = true
                    }, label: {
                        DanmakuMessageBubble(content: message.content, avatar: friend.avatar)
                            .offset(y: CGFloat(trackIndex) * trackHeight)
                    })
                    .buttonStyle(PlainButtonStyle())
                })
            }
            .onAppear(perform: {
                /// 初始化时记录历史聊天消息的数量.
                historyMessageCount = messageStoreViewModel.messages.count
            })
            .onChange(of: messageStoreViewModel.messages.count, {
                /// 将新的聊天消息添加到聊天消息列表中.
                messages.append(
                    contentsOf: messageStoreViewModel.messages[historyMessageCount..<messageStoreViewModel.messages.count]
                )
                historyMessageCount = messageStoreViewModel.messages.count
            })
            
            if appSettings.showDanmakuMessageInput {
                Text("弹幕聊天消息输入视图")
            }
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    let messageStoreViewModel = MessageStoreViewModel()

    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.addFriend(friend: User(clientID: 2025, name: "Steve"))

        return friendsViewModel
    }

    DanmakuSpace()
        .environment(appSettings)
        .environment(friendsViewModel)
        .environment(messageStoreViewModel)
        .onAppear(perform: {
            messageStoreViewModel.addMessage(message: Message(content: "你好", clientID: 2025))
        })
}
