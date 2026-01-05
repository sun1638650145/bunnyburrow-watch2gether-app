//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  SwipeableNSView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/7/23.
//

import AppKit
import Foundation

/// `SwipeableNSView`是处理水平滑动事件的`NSView`.
class SwipeableNSView: NSView {
    /// 水平滑动事件发生时调用的闭包.
    var onSwipe: (NSEvent) -> Void = { _ in }

    /// 控制水平滑动事件触发的频率, 防止重复响应.
    private var hasSwiped: Bool = false

    override func scrollWheel(with event: NSEvent) {
        guard !hasSwiped else {
            return
        }

        /// 仅在检测到水平滑动时触发.
        if event.scrollingDeltaX != 0 && event.scrollingDeltaY == 0 {
            hasSwiped = true

            onSwipe(event)

            /// 避免滑动事件抖动, 在1.5秒后重置.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.hasSwiped = false
            })
        }

        super.scrollWheel(with: event)
    }
}
