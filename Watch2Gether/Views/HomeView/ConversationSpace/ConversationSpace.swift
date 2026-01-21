//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  ConversationSpace.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/1/12.
//

import Foundation
import SwiftUI

/// `ConversationSpace`是聊天界面的视图,
/// 负责显示聊天消息列表, 聊天消息输入框以及发送按钮.
struct ConversationSpace: View {
    @Environment(User.self) var user
    @Environment(MessageStoreViewModel.self) var messageStoreViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 聊天消息输入框是否处于编辑焦点.
    @FocusState private var isFocused: Bool

    /// 聊天消息列表中最新消息的ID.
    @State private var lastMessageId: UUID?

    /// 聊天消息变量.
    @State private var message: String = ""

    /// 禁止发送按钮变量.
    private var isDisabled: Bool {
        return trimmedMessage.isEmpty
    }

    /// 去除首尾空格的聊天消息变量.
    private var trimmedMessage: String {
        return message.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        VStack(spacing: 0, content: {
            MessagesList(messageStoreViewModel.messages, lastMessageId: $lastMessageId)

            MessageInput($message, onMessageSend: sendMessage, isDisabled: isDisabled)
                .focused($isFocused)
        })
        .ignoresSafeArea()
        .onAppear(perform: {
            /// 添加接收聊天消息事件监听器给WebSocket客户端.
            webSocketClient.on(eventName: "receiveMessage", listener: { message, clientID in
                self.receiveMessage(message: message, clientID: clientID)
            })
        })
        .onChange(of: isFocused, {
            /// 聊天消息输入框处于编辑焦点时, 自动滚动至最新消息的位置.
            if isFocused {
                withAnimation(.easeInOut, {
                    lastMessageId = messageStoreViewModel.messages.last?.id
                })
            }
        })
    }

    /// 接收聊天消息.
    ///
    /// - Parameters:
    ///   - message: 聊天消息.
    ///   - clientID: 用户的客户端ID.
    private func receiveMessage(message: String, clientID: UInt) {
        /// 发送时聊天消息已经去除过首尾空格.
        messageStoreViewModel.addMessage(message: Message(content: message, clientID: clientID))
    }

    /// 发送聊天消息.
    private func sendMessage() {
        /// 禁止发送则直接返回.
        if isDisabled {
            return
        }

        webSocketClient.broadcast([
            "action": "chat",
            "message": trimmedMessage,
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": user.clientID
            ]
        ])

        /// 存储发送的聊天消息.
        messageStoreViewModel.addMessage(message: Message(content: trimmedMessage, clientID: user.clientID))

        /// 发送聊天消息后清空输入框.
        message = ""
    }
}

#Preview {
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let messageStoreViewModel = MessageStoreViewModel()
    let webSocketClient = WebSocketClient()

    ConversationSpace()
        .environment(user)
        .environment(friendsViewModel)
        .environment(messageStoreViewModel)
        .environment(webSocketClient)
}
