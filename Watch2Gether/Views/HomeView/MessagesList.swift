//
//  MessagesList.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/29.
//

import SwiftUI

struct MessagesList: View {
    /// 聊天消息列表变量.
    var messages: [Message]
    
    var body: some View {
        List(messages.indices, id: \.self, rowContent: { index in
            Text(messages[index].content)
                .listRowBackground(Color(hex: "#1A1D29"))
                .listRowSeparator(.hidden)
        })
        .listStyle(PlainListStyle())
    }
}

#Preview {
    var messages = [
        Message(content: "你好", clientID: 2023),
        Message(content: "Hi!", clientID: 2024)
    ]
    
    MessagesList(messages: messages)
}
