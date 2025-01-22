//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  StyledPlaceholderTextField.swift
//  iPadWatch2Gether
//
//  Create by Steve R. Sun on 2024/12/23.
//

import SwiftUI

/// `StyledPlaceholderTextField`是包含自定义样式占位文本的文本输入框视图.
struct StyledPlaceholderTextField: View {
    @Binding var text: String?

    /// 获取焦点位置.
    @FocusState private var isFocused: Bool

    /// 计算当前的边框颜色.
    private var borderColor: Color {
        if errorMesssage != nil {
            return .alertError
        } else if isFocused {
            return .textFieldHighlight
        } else {
            return .clear
        }
    }

    /// 错误信息文本.
    private var errorMesssage: String?

    /// 输入文本值更改时调用的闭包.
    private var onTextChange: (() -> Void)?

    /// 占位文本.
    private let placeholder: String

    /// 占位文本的颜色.
    private let placeholderColor: Color

    init(
        _ placeholder: String,
        text: Binding<String?>,
        placeholderColor: Color = .secondary,
        errorMessage: String? = nil,
        onTextChange: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.placeholderColor = placeholderColor
        self.errorMesssage = errorMessage
        self.onTextChange = onTextChange
    }

    var body: some View {
        VStack {
            ZStack(alignment: .leading, content: {
                if (text ?? "").isEmpty {
                    Text(placeholder)
                        .foregroundStyle(placeholderColor)
                        .padding(.leading, 5)
                }
                TextField("", text: Binding<String>(
                    get: { text ?? "" },
                    set: { text = $0.isEmpty ? nil : $0 }
                ))
                .autocorrectionDisabled()
                .focused($isFocused)
                .foregroundStyle(Color.foreground)
                .onChange(of: text, {
                    onTextChange?()
                })
                .padding(.leading, 5)
                #if os(macOS)
                .textFieldStyle(PlainTextFieldStyle())
                #endif
            })
            .frame(width: 350, height: 50)
            .background(Color.viewBackground)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title3)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1.2)
            })

            if let errorMesssage = errorMesssage {
                Text(errorMesssage)
                    .font(.callout)
                    .foregroundStyle(Color.alertError)
                    .padding(.top, 3)
            }
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
    }
}

#Preview {
    @Previewable @State var isNameEmpty = false
    @Previewable @State var name: String?
    @Previewable @State var url: String?

    Group {
        StyledPlaceholderTextField(
            "请输入昵称",
            text: $name,
            errorMessage: isNameEmpty ? "昵称不能为空, 请输入昵称并重试." : nil,
            onTextChange: {
                isNameEmpty = name?.isEmpty ?? true
            })

        StyledPlaceholderTextField("请输入流媒体视频源", text: $url)
    }
}
