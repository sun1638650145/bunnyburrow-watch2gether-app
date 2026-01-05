//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  ScrollableNSView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/3/14.
//

import AppKit

/// `ScrollableNSView`是处理滚动事件的`NSView`.
class ScrollableNSView: NSView {
    /// 滚动事件发生时调用的闭包.
    var onScrollWheel: (NSEvent) -> Void = { _ in }

    override func scrollWheel(with event: NSEvent) {
        onScrollWheel(event)
        super.scrollWheel(with: event)
    }
}
