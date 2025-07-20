//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ProgressLabel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/7/19.
//

import SwiftUI

/// `ProgressLabel`是播放进度标签视图.
struct ProgressLabel: View {
    /// 当前的播放时间(秒).
    let currentTime: Double

    /// 视频的总时长(秒).
    let totalDuration: Double

    var body: some View {
        HStack {
            FastPlaybackIcon(duration: 0.5)
                .scaleEffect(1.2)

            HStack(spacing: 0, content: {
                Text(currentTime.formattedTime())
                    .foregroundStyle(Color.progressLabelForeground)

                Text("/") + Text(totalDuration.formattedTime())
            })
            .font(.title)
            .fontWeight(.bold)
        }
        .foregroundStyle(Color.foreground)
    }
}

#Preview {
    ProgressLabel(currentTime: 439, totalDuration: 1225)
}
