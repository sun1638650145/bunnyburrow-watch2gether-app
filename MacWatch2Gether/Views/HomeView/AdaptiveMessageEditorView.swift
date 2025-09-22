//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AdaptiveMessageEditorView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/9/22.
//

import AppKit
import Foundation
import SwiftUI

/// `AdaptiveMessageEditorView`是使用`NSTextView`和`NSScrollView`实现的聊天消息高度自适应视图, 它允许用户输入聊天消息.
struct AdaptiveMessageEditorView: NSViewRepresentable {
    /// 视图的背景颜色.
    private let backgroundColor: NSColor

    /// 视图文本使用字体的颜色.
    private let textColor: NSColor

    init(backgroundColor: Color = .viewBackground, textColor: Color = .foreground) {
        self.backgroundColor = NSColor(backgroundColor)
        self.textColor = NSColor(textColor)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()

        /// 设置视图的背景颜色.
        textView.backgroundColor = backgroundColor

        /// 设置视图文本使用的字体.
        textView.font = Font.body.toNSFont()

        /// 设置视图文本使用字体的颜色.
        textView.textColor = textColor

        /// 设置视图文本内容的内边距(目前和body字体绑定).
        textView.textContainerInset = NSSize(width: 0, height: 12)

        let scrollView = NSScrollView()

        /// 设置`NSScrollView`的内容为`NSTextView`.
        scrollView.documentView = textView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        // ...
    }
}

#Preview {
    AdaptiveMessageEditorView()
        .frame(height: 40.0)
        .padding(10)
}
