//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MessageInput.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/26.
//

import SwiftUI

/// `MessageInput`是用于输入聊天消息并发送的视图.
struct MessageInput: View {
    @Binding var message: String

    /// 聊天消息发送时调用的闭包.
    private var onMessageSend: () -> Void

    /// 禁止发松按钮变量.
    private let isDisabled: Bool

    init(_ message: Binding<String>, onMessageSend: @escaping () -> Void = {}, isDisabled: Bool = true) {
        self._message = message
        self.onMessageSend = onMessageSend
        self.isDisabled = isDisabled
    }

    var body: some View {
        HStack {
            MessageField($message, onMessageSubmit: onMessageSend)

            Button(action: onMessageSend, label: {
                Text("发送")
                    .frame(width: 100, height: 40)
            })
            .buttonStyle(SendButtonStyle(isDisabled: isDisabled))
            .disabled(isDisabled)
        }
        /// 在iOS上设置键盘自适应.
        #if os(iOS)
        .keyboardAdaptive()
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
        #elseif os(macOS)
        .padding(10)
        #endif
        .background(Color.viewBackground.opacity(0.6))
    }
}

#Preview {
    @Previewable @State var message: String = ""

    MessageInput($message)
}
