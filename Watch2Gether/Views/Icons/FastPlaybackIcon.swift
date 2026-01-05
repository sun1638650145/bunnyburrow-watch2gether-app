//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  FastPlaybackIcon.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/11.
//

import SwiftUI

/// `FastPlaybackIcon`是倍速播放状态图标.
struct FastPlaybackIcon: View {
    /// 用于控制显示第一个图标变量.
    @State private var showFirstIcon = true

    /// 动画持续的时间(秒).
    var duration: Double = 1.0

    /// 是否反转图标的方向.
    var isFlipped: Bool = false

    var body: some View {
        HStack(spacing: -3, content: {
            Image(systemName: "play.fill")
                .opacity(showFirstIcon ? 1 : 0)

            Image(systemName: "play.fill")
                .opacity(showFirstIcon ? 0 : 1)
        })
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: duration).repeatForever(), {
                showFirstIcon = false
            })
        })
        .rotationEffect(.degrees(isFlipped ? 180 : 0))
    }
}

#Preview {
    FastPlaybackIcon(duration: 0.5)
}
