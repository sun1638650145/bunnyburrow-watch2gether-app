//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DanmakuSpace.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/17.
//

import SwiftUI

/// `DanmakuSpace`是在视频播放器全屏时, 用于以弹幕形式显示收到聊天消息的视图;
/// 它会监听聊天消息的变化, 并将新消息以弹幕形式显示.
struct DanmakuSpace: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(MessageStoreViewModel.self) var messageStoreViewModel

    /// 全屏时收到的聊天消息列表变量.
    @State private var messages: [Message] = []

    /// 已处理的聊天消息计数, 用于追踪全屏状态下新增消息的显示.
    @State private var handledMessageCount: Int = 0

    var body: some View {
        ForEach(messages.indices, id: \.self, content: { index in
            let message = messages[index]
            let friend = friendsViewModel.searchFriend(by: message.clientID)!

            DanmakuMessageBubble(content: message.content, avatar: friend.avatar)
        })
        .onAppear(perform: {
            /// 仅展示全屏状态下收到聊天消息, 忽略进入全屏前的历史消息.
            handledMessageCount = messageStoreViewModel.messages.count
        })
        .onChange(of: appSettings.isFullScreen, {
            /// 视频播放器退出全屏时, 清空当前的聊天消息列表, 避免重复显示.
            if !appSettings.isFullScreen {
                messages.removeAll()
                handledMessageCount = messageStoreViewModel.messages.count
            }
        })
        .onChange(of: messageStoreViewModel.messages.count, {
            /// 当视频播放器全屏时, 将新增的聊天消息到聊天消息列表中.
            if appSettings.isFullScreen {
                let newCount = messageStoreViewModel.messages.count
                let newMessages = messageStoreViewModel.messages[handledMessageCount..<newCount]

                messages.append(contentsOf: newMessages)
                handledMessageCount = newCount
            }
        })
    }
}
