//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  StyledPlaceholderTextField.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/12/22.
//

import SwiftUI

/// `StyledPlaceholderTextField`是包含自定义样式占位文本的文本输入框视图.
struct StyledPlaceholderTextField: View {
    @Binding var text: String?

    /// 是否处于编辑焦点.
    @FocusState private var isFoused: Bool

    /// 错误文本信息.
    private let errorMessage: LocalizedStringResource?

    /// 输入文本值更改时调用的闭包.
    private let onTextChange: () -> Void

    /// 占位文本.
    private let placeholder: LocalizedStringResource

    /// 占位文本的颜色.
    private let placeholderColor: Color

    /// 计算当前的边框颜色.
    private var borderColor: Color {
        if errorMessage != nil {
            return .alertError
        } else if isFoused {
            return .textFieldHighlight
        } else {
            return .clear
        }
    }

    init(
        _ placeholder: LocalizedStringResource,
        text: Binding<String?>,
        placeholderColor: Color = .secondary,
        errorMessage: LocalizedStringResource? = nil,
        onTextChange: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.placeholderColor = placeholderColor
        self.errorMessage = errorMessage
        self.onTextChange = onTextChange
    }

    var body: some View {
        VStack {
            ZStack(alignment: .leading, content: {
                if (text ?? "").isEmpty {
                    Text(placeholder)
                        .foregroundStyle(placeholderColor)
                }

                TextField("", text: Binding<String>(
                    get: { text ?? "" },
                    set: { text = $0.isEmpty ? nil : $0 }
                ))
                .autocorrectionDisabled()
                .focused($isFoused)
                .foregroundStyle(Color.foreground)
                .onChange(of: text, onTextChange)
                .textFieldStyle(PlainTextFieldStyle())
            })
            .padding(.leading, 10)
            .frame(width: 350, height: 50)
            .overlay(alignment: .bottom, content: {
                if errorMessage != nil || isFoused {
                    Capsule()
                        .stroke(borderColor, lineWidth: 1.2)
                } else {
                    Rectangle()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .frame(height: 1)
                }
            })

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundStyle(Color.alertError)
                    .padding(.top, 3)
            }
        }
    }
}

#Preview {
    @Previewable @State var isNameEmpty: Bool = false
    @Previewable @State var name: String?
    @Previewable @State var webSocketUrl: String?

    Group {
        StyledPlaceholderTextField(
            "请输入昵称",
            text: $name,
            errorMessage: isNameEmpty ? "昵称不能为空, 请输入昵称并重试." : nil,
            onTextChange: {
                isNameEmpty = name?.isEmpty ?? true
            }
        )

        StyledPlaceholderTextField("请输入WebSocket服务地址", text: $webSocketUrl)
    }
    .padding(10)
}
