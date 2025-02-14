//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
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
    @Environment(WebSocketClient.self) var webSocketClient

    /// 聊天消息变量.
    @State private var message: String = ""

    /// 聊天消息列表变量.
    @State private var messages: [Message] = []

    /// 禁止发送按钮变量.
    private var isDisabled: Bool {
        return trimmedMessage.isEmpty
    }

    /// 去除首尾空格的聊天消息变量.
    private var trimmedMessage: String {
        return message.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        VStack {
            MessagesList(messages)

            Spacer()

            HStack {
                MessageField($message, onMessageSubmit: sendMessage)

                Button(action: sendMessage, label: {
                    Text("发送")
                        .frame(width: 100, height: 40)
                })
                .buttonStyle(SendButtonStyle(isDisabled: isDisabled))
                .disabled(isDisabled)
            }
            .padding(10)
        }
        .onAppear(perform: {
            /// 添加接收聊天消息事件监听器给WebSocket客户端.
            webSocketClient.on(eventName: "receiveMessage", listener: { message, clientID in
                self.receiveMessage(message: message, clientID: clientID)
            })
        })
    }

    /// 接收聊天消息.
    ///
    /// - Parameters:
    ///   - message: 聊天消息.
    ///   - clientID: 用户的客户端ID.
    private func receiveMessage(message: String, clientID: UInt) {
        /// 发送时聊天消息已经去除过首尾空格.
        messages.append(Message(content: message, clientID: clientID))
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
        messages.append(Message(content: trimmedMessage, clientID: user.clientID))

        /// 发送聊天消息后清空输入框.
        message = ""
    }
}

#Preview {
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let webSocketClient = WebSocketClient()

    ConversationSpace()
        .environment(user)
        .environment(friendsViewModel)
        .environment(webSocketClient)
}
