//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  MessageInput.swift
//  iPadWatch2Gether
//
//  Created by Steve R. Sun on 2025/9/17.
//

import SwiftUI

/// `MessageInput`是用于输入并发送聊天消息的视图.
struct MessageInput: View {
    @Binding var message: String

    /// 聊天消息发送时调用的闭包.
    private var onMessageSend: () -> Void

    /// 禁止发送按钮变量.
    private let isDisabled: Bool

    init(_ message: Binding<String>, onMessageSend: @escaping () -> Void = {}, isDisabled: Bool = true) {
        self._message = message
        self.onMessageSend = onMessageSend
        self.isDisabled = isDisabled
    }

    var body: some View {
        HStack(alignment: .bottom, content: {
            AdaptiveMessageEditor($message, onMessageSubmit: onMessageSend)

            Button(action: onMessageSend, label: {
                Text("Send")
                    .frame(width: 100, height: 40)
            })
            .buttonStyle(SendButtonStyle(isDisabled: isDisabled))
            .disabled(isDisabled)
        })
        #if os(iOS)
        .keyboardAdaptive(keyboardRestBottomInset: 15)
        #endif
        .padding(10)
        .background(Color.viewBackground.opacity(0.6))
    }
}

#Preview {
    @Previewable @State var message: String = ""

    MessageInput($message)
}
