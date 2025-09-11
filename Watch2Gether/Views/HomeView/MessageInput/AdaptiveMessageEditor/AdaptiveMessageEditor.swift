//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AdaptiveMessageEditor.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/9/10.
//

import SwiftUI

/// `AdaptiveMessageEditor`是聊天消息高度自适应视图, 它允许用户输入聊天消息.
struct AdaptiveMessageEditor: View {
    @Binding var message: String

    /// 当前视图的高度(随输入的聊天消息变化).
    @State private var height: CGFloat = 40

    /// 视图的最大高度.
    private let maxHeight: CGFloat

    /// 聊天消息提交时调用的闭包.
    private var onMessageSubmit: () -> Void

    init(_ message: Binding<String>, onMessageSubmit: @escaping () -> Void = {}, maxHeight: CGFloat = 125.0) {
        self._message = message
        self.onMessageSubmit = onMessageSubmit
        self.maxHeight = maxHeight
    }

    var body: some View {
        AdaptiveMessageEditorView(text: $message, height: $height, onSubmit: onMessageSubmit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height: min(height, maxHeight))
    }
}

#Preview {
    @Previewable @State var message = ""

    AdaptiveMessageEditor($message)
        .padding(10)
}
