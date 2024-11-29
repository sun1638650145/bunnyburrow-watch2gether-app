//
//  ChatRoom.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/27.
//

import Foundation
import SwiftUI

struct ChatRoom: View {
    @Environment(User.self) var user
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 聊天消息变量.
    @State private var message: String = ""
    
    /// 聊天消息列表变量.
    @State private var messages: [Message] = []
    
    /// 禁用发送按钮变量.
    private var isDisabled: Bool {
        return message.isEmpty
    }
    
    /// 去除前后空格的聊天消息变量.
    private var trimmedMessage: String {
        return message.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var body: some View {
        VStack {
            /// 用于临时模拟聊天消息列表组件.
            Color.blue
            
            HStack {
                ChatInputTextField(text: $message, onTextSubmit: sendMessage)
                
                Button(action: sendMessage, label: {
                    Text("发送")
                        .frame(width: 100, height: 35)
                })
                .buttonStyle(SendButtonStyle(isDisabled: isDisabled))
                .disabled(isDisabled)
            }
            .padding(10)
        }
        .onAppear(perform: {
            /// 添加接收聊天消息事件监听函数给WebSocket客户端.
            websocketClient.on(eventName: "receiveMessage", listener: {
                receiveMessage(message: $0, clientID: $1)
            })
        })
    }
    
    private func receiveMessage(message: String, clientID: UInt) {
        /// 发送的聊天消息已经执行过`trimmingCharacters(in: CharacterSet.whitespaces)`.
        messages.append(Message(content: message, clientID: clientID))
    }
    
    private func sendMessage() {
        /// 聊天消息为空则直接返回.
        if trimmedMessage.isEmpty {
            return
        }
        
        websocketClient.broadcast([
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
    let user = User(nil, "")
    let websocketClient = WebSocketClient()
    
    ChatRoom()
        .environment(user)
        .environment(websocketClient)
}
