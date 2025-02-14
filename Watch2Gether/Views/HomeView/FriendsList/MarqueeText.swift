//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MarqueeText.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/1/7.
//

import SwiftUI

/// `MarqueeText`是支持跑马灯效果的文本视图;
/// 当文本的渲染宽度超过视图宽度时, 会自动滚动显示.
struct MarqueeText: View {
    /// 滚动状态.
    @State private var isScrolling = false

    /// 文本的颜色.
    private let color: Color

    /// 滚动动画持续的时间(秒).
    private let duration: Double

    /// 文本使用的字体.
    private let font: Font

    /// 要展示的文本内容.
    private let text: String

    /// 文本的渲染高度.
    private var textRenderedHeight: Double {
        /// 在iOS上使用`toUIFont`将`Font`转换成`UIFont`.
        #if os(iOS)
        return text.renderedHeight(usingFont: font.toUIFont())

        /// 在macOS上使用`toNSFont`将`Font`转换成`NSFont`.
        #elseif os(macOS)
        return text.renderedHeight(usingFont: font.toNSFont())
        #endif
    }

    /// 文本的渲染宽度.
    private var textRenderedWidth: Double {
        /// 在iOS上使用`toUIFont`将`Font`转换成`UIFont`.
        #if os(iOS)
        return text.renderedWidth(usingFont: font.toUIFont())

        /// 在macOS上使用`toNSFont`将`Font`转换成`NSFont`.
        #elseif os(macOS)
        return text.renderedWidth(usingFont: font.toNSFont())
        #endif
    }

    init(_ text: String, duration: Double = 5.0, color: Color = .primary, font: Font = .body) {
        self.text = text
        self.duration = duration
        self.color = color
        self.font = font
    }

    var body: some View {
        GeometryReader(content: { geometry in
            /// 如果渲染宽度超出视图宽度, 则启动滚动效果.
            if textRenderedWidth > geometry.size.width {
                HStack(spacing: geometry.size.width, content: {
                    Text(text)

                    /// 用于无缝滚动的衔接.
                    Text(text)
                })
                .fixedSize(horizontal: true, vertical: false)
                /// 需要文本的渲染宽度偏移出画面后加上文本间隔宽度才像是无缝滚动.
                .offset(x: isScrolling ? -(textRenderedWidth + geometry.size.width) : 0)
            } else {
                Text(text)
                    /// 使文本填满父容器并保持水平居中.
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        })
        .clipped()
        .font(font)
        .foregroundStyle(color)
        .frame(height: textRenderedHeight)
        .onAppear(perform: {
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false), {
                isScrolling = true
            })
        })
    }
}

#Preview {
    Group {
        MarqueeText("超过视图宽度的文本", duration: 6.0)

        MarqueeText("文本")
    }
    .frame(width: 50)
}
