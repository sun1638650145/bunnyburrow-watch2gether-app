//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  AdaptiveMessageEditorView.swift
//  iPadWatch2Gether
//
//  Created by Steve R. Sun on 2025/9/17.
//

import SwiftUI
import UIKit

/// `AdaptiveMessageEditorView`是使用`UITextView`实现的聊天消息高度自适应视图, 它允许用户输入聊天消息.
struct AdaptiveMessageEditorView: UIViewRepresentable {
    @Binding var height: CGFloat
    @Binding var text: String

    /// 视图的背景颜色.
    private let backgroundColor: UIColor

    /// 视图的最小高度.
    private let minHeight: CGFloat

    /// 点击回车键时调用的闭包.
    private let onSubmit: () -> Void

    /// 视图文本使用字体的颜色.
    private let textColor: UIColor

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
        self.backgroundColor = UIColor(backgroundColor)
        self.textColor = UIColor(textColor)
        self.onSubmit = onSubmit
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        /// 设置视图的背景颜色.
        textView.backgroundColor = backgroundColor

        /// 委托`Coordinator`处理.
        textView.delegate = context.coordinator

        /// 设置视图文本使用的字体.
        textView.font = Font.body.toUIFont()

        /// 设置回车键的标签为发送.
        textView.returnKeyType = .send

        /// 设置视图文本使用字体的颜色.
        textView.textColor = textColor

        /// 设置视图文本内容的内边距(目前和body字体绑定).
        textView.textContainerInset = UIEdgeInsets(top: 8.9, left: 0, bottom: 8.9, right: 0)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        /// 将绑定的文本同步到视图文本上.
        if uiView.text != text {
            uiView.text = text
        }

        /// 将视图高度更新到绑定的高度上.
        if height < uiView.contentSize.height || uiView.text.isEmpty {
            DispatchQueue.main.async(execute: {
                height = max(minHeight, uiView.contentSize.height)
            })
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AdaptiveMessageEditorView

        init(_ parent: AdaptiveMessageEditorView) {
            self.parent = parent
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            /// 当用户点击回车键时, 调用`onSubmit`并阻止插入换行符.
            if text == "\n" {
                parent.onSubmit()

                /// 退出第一响应者状态, 隐藏键盘.
                textView.resignFirstResponder()

                return false
            }

            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            /// 将视图文本更新到绑定的文本中.
            parent.text = textView.text

            /// 将视图高度更新到绑定的高度上.
            parent.height = max(parent.minHeight, textView.contentSize.height)
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
}
