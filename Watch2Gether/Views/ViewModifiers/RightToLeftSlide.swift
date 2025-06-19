//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  RightToLeftSlide.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/19.
//

import SwiftUI

/// `RightToLeftSlide`是用于使目标视图从右向左滑动的视图修饰符.
struct RightToLeftSlide: ViewModifier {
    /// 视图水平方向的偏移量.
    @State private var offset: CGFloat = 0.0

    /// 滑动动画持续的时间(秒).
    var duration: Double = 10.0

    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            content
                .offset(x: offset)
                .onAppear(perform: {
                    /// 设置视图初始位置.
                    offset = geometry.size.width

                    withAnimation(.linear(duration: duration), {
                        offset = -geometry.size.width
                    })
                })
        })
    }
}

#Preview {
    Text("Hello, World!")
        .modifier(RightToLeftSlide())
}
