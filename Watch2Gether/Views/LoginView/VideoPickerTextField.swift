//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPickerTextField.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/12/1.
//

import Foundation
import SwiftUI

/// `VideoPickerTextField`是包含视频选择功能的文本输入框视图, 允许用户选择一个本地视频文件.
struct VideoPickerTextField: View {
    @Binding var text: String?

    /// 显示在文本输入框中的文本(如果是文件URL则只显示文件名, 其他情况则为完整的原始文本).
    @State private var displayText: String?

    /// 是否呈现`VideoPickerViewController`.
    @State private var isPresented: Bool = false

    /// 错误文本信息.
    private let errorMessage: LocalizedStringResource?

    /// 输入文本值更改时调用的闭包.
    private let onTextChange: () -> Void

    /// 占位文本.
    private let placeholder: LocalizedStringResource

    /// 占位文本的颜色.
    private let placeholderColor: Color

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
            HStack(spacing: 0, content: {
                ZStack(alignment: .leading, content: {
                    if (text ?? "").isEmpty {
                        Text(placeholder)
                            .foregroundStyle(placeholderColor)
                    }

                    TextField("", text: Binding<String>(
                        get: { displayText ?? "" },
                        set: { newValue in
                            /// 用户手动输入文本, 则跟随显示输入的完整文本.
                            displayText = newValue

                            if newValue.isEmpty {
                                text = nil
                            } else {
                                text = newValue
                            }
                        }
                    ))
                    .autocorrectionDisabled()
                    .foregroundStyle(Color.foreground)
                    .onChange(of: text, onTextChange)
                })
                .padding(.leading, 10)

                Button(action: {
                    isPresented = true
                }, label: {
                    Image(systemName: "chevron.down.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color.foreground)
                        .frame(width: 22, height: 22)
                })
                .padding(.horizontal, 10)
                .sheet(isPresented: $isPresented, content: {
                    VideoPickerViewController(selectedVideo: Binding<String?>(
                        get: { text },
                        set: { newValue in
                            text = newValue

                            /// 如果是文件URL则只显示文件名.
                            if let text = text, let url = URL(string: text), url.isFileURL {
                                displayText = url.lastPathComponent
                            } else {
                                displayText = text
                            }
                        }
                    ))
                })
            })
            .frame(width: 350, height: 50)
            .onAppear(perform: {
                /// 初始化时如果是文件URL则只显示文件名.
                if let text = text, let url = URL(string: text), url.isFileURL {
                    displayText = url.lastPathComponent
                } else {
                    displayText = text
                }
            })
            .onChange(of: text, {
                /// 当绑定的文本为空时, 更新显示的文本.
                if (text ?? "").isEmpty {
                    displayText = text
                }
            })
            .overlay(alignment: .bottom, content: {
                if errorMessage != nil {
                    Capsule()
                        .stroke(Color.textFieldHighlight, lineWidth: 1.2)
                } else {
                    Rectangle()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .frame(height: 1)
                }
            })

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(Color.textFieldHighlight)
                    .padding(.top, 3)
            }
        }
    }
}

#Preview {
    @Previewable @State var isStreamingInvalid = false
    @Previewable @State var url: String?

    VideoPickerTextField(
        "请输入流媒体视频源或选择本地视频源",
        text: $url,
        errorMessage: isStreamingInvalid ? "视频源为空或者不合法, 请重新输入视频源并重试." : nil,
        onTextChange: {
            isStreamingInvalid = url?.isEmpty ?? true
        }
    )
}
