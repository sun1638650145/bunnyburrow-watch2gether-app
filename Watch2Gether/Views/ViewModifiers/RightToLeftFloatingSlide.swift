//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  RightToLeftFloatingSlide.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/19.
//

import SwiftUI

/// `RightToLeftFloatingSlide`是用于使目标`View`从右向左滑动, 并在垂直方向上随机偏移漂浮的视图修饰符.
struct RightToLeftFloatingSlide: ViewModifier {
    /// 视图水平方向的偏移量.
    @State private var xOffset: CGFloat = 0.0

    /// 视图垂直方向的偏移量, 为屏幕高度上1/3范围内的随机值.
    @State private var yOffset: CGFloat = 0.0

    /// 滑动动画持续的时间(秒).
    var duration: Double = 10.0

    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            content
                .offset(x: xOffset, y: yOffset)
                .onAppear(perform: {
                    /// 设置视图初始位置.
                    xOffset = geometry.size.width
                    yOffset = CGFloat.random(in: 0.0...geometry.size.height / 3)

                    withAnimation(.linear(duration: duration), {
                        xOffset = -geometry.size.width
                    })
                })
        })
    }
}

#Preview {
    Text("Hello, World!")
        .modifier(RightToLeftFloatingSlide())
}
