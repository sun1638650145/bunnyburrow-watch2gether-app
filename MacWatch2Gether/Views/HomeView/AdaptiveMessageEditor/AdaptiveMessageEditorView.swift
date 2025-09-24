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
    @Binding var height: CGFloat
    @Binding var text: String

    /// 视图的背景颜色.
    private let backgroundColor: NSColor

    /// 视图的最小高度.
    private let minHeight: CGFloat

    /// 点击回车键时调用的闭包.
    private let onSubmit: () -> Void

    /// 视图文本使用字体的颜色.
    private let textColor: NSColor

    init(
        text: Binding<String>,
        height: Binding<CGFloat>,
        minHeight: CGFloat,
        backgroundColor: Color = .viewBackground,
        textColor: Color = .foreground,
        onSubmit: @escaping () -> Void = {}
    ) {
        self._text = text
        self._height = height
        self.minHeight = minHeight
        self.backgroundColor = NSColor(backgroundColor)
        self.textColor = NSColor(textColor)
        self.onSubmit = onSubmit
    }

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()

        /// 设置视图的背景颜色.
        textView.backgroundColor = backgroundColor

        /// 委托`Coordinator`处理.
        textView.delegate = context.coordinator

        /// 设置视图文本使用的字体.
        textView.font = Font.body.toNSFont()

        /// 设置视图文本使用字体的颜色.
        textView.textColor = textColor

        /// 设置视图文本内容的内边距(目前和body字体绑定).
        textView.textContainerInset = NSSize(width: 0, height: 12)

        let scrollView = NSScrollView()

        /// 设置`NSScrollView`的内容为`NSTextView`.
        scrollView.documentView = textView

        /// 禁止`NSScrollView`绘制背景(使之透明).
        scrollView.drawsBackground = false

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        /// 确保数据类型为`NSTextView`.
        guard let textView = nsView.documentView as? NSTextView
        else {
            return
        }

        /// 将绑定的文本同步到视图文本上.
        if textView.string != text {
            textView.string = text
        }
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AdaptiveMessageEditorView

        init(_ parent: AdaptiveMessageEditorView) {
            self.parent = parent
        }

        func textView(
            _ textView: NSTextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementString: String?
        ) -> Bool {
            /// 当用户点击回车键时, 调用`onSubmit`并阻止插入换行符.
            if replacementString == "\n" {
                parent.onSubmit()

                return false
            }

            return true
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            /// 确保数据类型为`NSTextView`.
            guard let textView = notification.object as? NSTextView
            else {
                return
            }

            /// 将视图文本更新到绑定的文本中.
            parent.text = textView.string

            /// 获取文本容器和排版文本的布局管理器.
            if let textContainer = textView.textContainer, let layoutManager = textView.layoutManager {
                /// 强制执行排版布局.
                layoutManager.ensureLayout(for: textContainer)

                /// 获取视图文本的矩形边界.
                let rect = layoutManager.usedRect(for: textContainer)

                /// 将视图高度更新到绑定的高度上.
                DispatchQueue.main.async(execute: {
                    self.parent.height = max(self.parent.minHeight, rect.height)
                })
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

#Preview {
    @Previewable @State var message = ""
    @Previewable @State var height: CGFloat = 40.0

    let minHeight: CGFloat = 40.0

    AdaptiveMessageEditorView(text: $message, height: $height, minHeight: minHeight)
        .frame(height: min(height, 100.0))
        .padding(10)
}
