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
    
    /// 禁用发送按钮变量.
    private var isDisabled: Bool {
        return message.isEmpty
    }
    
    var body: some View {
        /// 用于临时模拟聊天消息列表组件.
        Color.blue
        
        HStack {
            TextField("", text: $message)
                .frame(height: 35)
                .padding(.leading, 5)
                .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(Color(hex: "#E5E7EB"))
                .onSubmit(sendMessage)
                #if os(iOS)
                /// 在iOS上设置提交按钮的标签为发送.
                .submitLabel(.send)
                #elseif os(macOS)
                .textFieldStyle(PlainTextFieldStyle())
                #endif
            
            Button(action: sendMessage, label: {
                Text("发送")
                    .frame(width: 100, height: 35)
            })
            .buttonStyle(SendButtonStyle(isDisabled: isDisabled))
            .disabled(isDisabled)
        }
        .padding(10)
    }
    
    private func sendMessage() {
        /// 聊天消息为空则直接返回.
        if message.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            return
        }
        
        websocketClient.broadcast([
            "action": "chat",
            "message": message,
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": user.clientID
            ]
        ])
        
        // 发送聊天消息后清空输入框.
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
