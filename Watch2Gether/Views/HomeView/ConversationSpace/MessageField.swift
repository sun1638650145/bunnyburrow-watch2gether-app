//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MessageField.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/1/12.
//

import SwiftUI

/// `MessageField`是聊天消息输入框视图, 它允许用户输入聊天消息.
struct MessageField: View {
    @Binding var message: String

    /// 聊天消息提交时调用的闭包.
    private var onMessageSubmit: () -> Void

    init(_ message: Binding<String>, onMessageSubmit: @escaping () -> Void = {}) {
        self._message = message
        self.onMessageSubmit = onMessageSubmit
    }

    var body: some View {
        TextField("", text: $message)
            .frame(height: 40)
            .padding(.leading, 5)
            .background(Color.viewBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(Color.foreground)
            .onSubmit(onMessageSubmit)
            /// 在iOS上设置提交按钮的标签为发送.
            #if os(iOS)
            .submitLabel(.send)
            #elseif os(macOS)
            .textFieldStyle(PlainTextFieldStyle())
            #endif
    }
}

#Preview {
    @Previewable @State var message = ""

    MessageField($message)
        .padding(10)
}
