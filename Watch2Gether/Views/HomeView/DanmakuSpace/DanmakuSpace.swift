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
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(MessageStoreViewModel.self) var messageStoreViewModel

    /// 聊天消息列表变量.
    @State private var messages: [Message] = []

    /// 历史聊天消息计数, 用于忽略视图出现前的聊天消息.
    @State private var historyMessageCount: Int = 0

    var body: some View {
        ZStack {
            ForEach(messages.indices, id: \.self, content: { index in
                let message = messages[index]
                let friend = friendsViewModel.searchFriend(by: message.clientID)!

                DanmakuMessageBubble(content: message.content, avatar: friend.avatar)
                    .rightToLeftSlide()
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
    }
}
