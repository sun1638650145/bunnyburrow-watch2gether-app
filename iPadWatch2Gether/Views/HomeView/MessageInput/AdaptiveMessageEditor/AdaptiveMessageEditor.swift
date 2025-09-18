//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AdaptiveMessageEditor.swift
//  iPadWatch2Gether
//
//  Created by Steve R. Sun on 2025/9/17.
//

import SwiftUI

/// `AdaptiveMessageEditor`是聊天消息高度自适应视图, 它允许用户输入聊天消息.
struct AdaptiveMessageEditor: View {
    @Binding var message: String

    /// 当前视图的高度(随输入的聊天消息变化).
    @State private var height: CGFloat = 62.5

    /// 视图的最大高度.
    @State private var maxHeight: CGFloat

    /// 视图的最小高度.
    private let minHeight: CGFloat

    /// 聊天消息提交时调用的闭包.
    private var onMessageSubmit: () -> Void

    init(
        _ message: Binding<String>,
        onMessageSubmit: @escaping () -> Void = {},
        minHeight: CGFloat = 62.5,
        maxHeight: CGFloat = 125.0
    ) {
        self._message = message
        self.onMessageSubmit = onMessageSubmit
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }

    var body: some View {
        AdaptiveMessageEditorView(text: $message, height: $height, minHeight: minHeight, onSubmit: onMessageSubmit)
            .background(
                GeometryReader(content: { geometry in
                    /// 用于获取`AdaptiveMessageEditorView`的视图宽度且不影响布局.
                    Color.clear
                        .onAppear(perform: {
                            /// 当视图宽度较小时(说明在横屏使用), 限制最大高度避免布局错误.
                            if geometry.size.width < 220 {
                                maxHeight = 70.0
                            }
                        })
                        /// 用于处理台前调度或窗口化App的情况.
                        .onChange(of: geometry.size.width, {
                            maxHeight = geometry.size.width < 220 ? 70.0 : 125.0
                        })
                })
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height: min(height, maxHeight))
    }
}

#Preview {
    @Previewable @State var message = ""

    AdaptiveMessageEditor($message)
        .padding(10)
}
