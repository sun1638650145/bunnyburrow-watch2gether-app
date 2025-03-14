//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ScrollableView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/3/14.
//

import SwiftUI

/// `ScrollableView`是基于`NSViewRepresentable`实现的处理滚动事件视图; 它通过`onScrollWheel`处理滚轮事件.
struct ScrollableView: NSViewRepresentable {
    /// 滚动事件发生时调用的闭包.
    let onScrollWheel: (NSEvent) -> Void

    func makeNSView(context: Context) -> ScrollableNSView {
        let view = ScrollableNSView()

        view.onScrollWheel = onScrollWheel

        return view
    }

    func updateNSView(_ nsView: ScrollableNSView, context: Context) {
        // ...
    }
}
