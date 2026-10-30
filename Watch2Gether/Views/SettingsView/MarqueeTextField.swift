//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  MarqueeTextField.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2026/10/29.
//

import SwiftUI

/// `MarqueeTextField`是支持跑马灯效果的文本输入框视图;
/// 在非编辑状态下, 当文本的渲染宽度超过视图宽度时, 会自动滚动显示.
struct MarqueeTextField: View {
    @Binding var text: String

    /// 文本是否正在编辑变量.
    @State private var isEditing: Bool = false

    /// 对齐方式.
    private let alignment: Alignment

    /// 文本的颜色.
    private let color: Color

    /// 滚动动画持续的时间(秒).
    private let duration: Double

    /// 输入文本值更改时调用的闭包.
    private let onTextChange: (String) -> Void

    /// 文本的对齐方式.
    private var textAlignment: TextAlignment {
        switch alignment {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .center
        }
    }

    init(
        text: Binding<String>,
        duration: Double = 5.0,
        alignment: Alignment = .center,
        color: Color = .secondary,
        onTextChange: @escaping (String) -> Void = { _ in }
    ) {
        self._text = text
        self.duration = duration
        self.alignment = alignment
        self.color = color
        self.onTextChange = onTextChange
    }

    var body: some View {
        Group {
            if isEditing {
                TextField("", text: $text)
                    .foregroundStyle(color)
                    .multilineTextAlignment(textAlignment)
                    .onSubmit({
                        isEditing = false
                    })
            } else {
                MarqueeText(text, duration: duration, alignment: alignment, color: color)
                    .onTapGesture(perform: {
                        isEditing = true
                    })
            }
        }
        .onChange(of: text, {
            onTextChange(text)
        })
    }
}

#Preview {
    @Previewable @State var text: String = "超过视图宽度的文本"

    Group {
        MarqueeTextField(text: $text, duration: 6.0)

        MarqueeTextField(text: .constant("文本"))
    }
    .frame(width: 50)
}
