//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AdaptiveMessageEditorView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/9/9.
//

import SwiftUI
import UIKit

/// `AdaptiveMessageEditorView`是使用`UITextView`实现的聊天消息高度自适应视图, 它允许用户输入聊天消息.
struct AdaptiveMessageEditorView: UIViewRepresentable {
    @Binding var text: String

    /// 视图的背景颜色.
    private let backgroundColor: UIColor

    /// 视图文本使用字体的颜色.
    private let textColor: UIColor

    init(text: Binding<String>, backgroundColor: Color = .viewBackground, textColor: Color = .foreground) {
        self._text = text
        self.backgroundColor = UIColor(backgroundColor)
        self.textColor = UIColor(textColor)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        /// 设置视图的背景颜色.
        textView.backgroundColor = backgroundColor

        /// 委托`Coordinator`处理.
        textView.delegate = context.coordinator

        /// 设置视图文本使用的字体.
        textView.font = Font.body.toUIFont()

        /// 设置视图文本使用字体的颜色.
        textView.textColor = textColor

        /// 设置视图文本内容的内边距(目前和body字体绑定).
        textView.textContainerInset = UIEdgeInsets(top: 9.85, left: 0, bottom: 9.85, right: 0)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // ...
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AdaptiveMessageEditorView

        init(_ parent: AdaptiveMessageEditorView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            /// 将视图文本更新到绑定文本中.
            parent.text = textView.text
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

#Preview {
    @Previewable @State var message = ""

    AdaptiveMessageEditorView(text: $message)
        .frame(height: 40)
}
