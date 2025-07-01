//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  RightToLeftSlide.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/19.
//

import Foundation
import SwiftUI

/// `RightToLeftSlide`是用于使`View`从右向左滑动的视图修饰符.
struct RightToLeftSlide: ViewModifier {
    /// 用于控制滑动动画帧率的定时器.
    @State private var animationTimer: Timer?

    /// 视图所在容器的宽度.
    @State private var containerWidth: CGFloat = 0.0

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

                    /// 获取视图所在容器的宽度.
                    containerWidth = geometry.size.width

                    beginAnimation()
                })
        })
    }

    /// 启动滑动动画, 通过定时器以120帧更新视图水平方向的偏移量.
    private func beginAnimation() {
        /// 每帧滑动的距离(此处简化计算, 当视图宽度为容器宽度时, 则最大移动距离为2倍容器宽度).
        let distancePerFrame = (2 * containerWidth) / duration / 120

        animationTimer = Timer.scheduledTimer(withTimeInterval: 1 / 120, repeats: true, block: { _ in
            offset -= distancePerFrame

            /// 当视图完全移出容器后, 关闭定时器.
            if offset < -containerWidth {
                animationTimer?.invalidate()
            }
        })
    }
}

#Preview {
    Text("Hello, World!")
        .modifier(RightToLeftSlide())
}
