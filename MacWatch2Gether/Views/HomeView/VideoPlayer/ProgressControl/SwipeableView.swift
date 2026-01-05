//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  SwipeableView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/7/23.
//

import SwiftUI

/// `SwipeableView`是基于`NSViewRepresentable`实现的处理水平滑动事件视图; 它通过`onSwipe`处理水平滑动事件.
struct SwipeableView: NSViewRepresentable {
    /// 水平滑动事件发生时调用的闭包.
    let onSwipe: (NSEvent) -> Void

    func makeNSView(context: Context) -> SwipeableNSView {
        let view = SwipeableNSView()

        view.onSwipe = onSwipe

        return view
    }

    func updateNSView(_ nsView: SwipeableNSView, context: Context) {
        // ...
    }
}
