//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ProgressBar.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/7.
//

import AVKit
import SwiftUI

/// `ProgressBar`是视频播放进度条视图, 支持实时显示播放进度和用户交互.
struct ProgressBar: View {
    @Environment(StreamingViewModel.self) var streamingViewModel

    /// 进度调整完成时调用的闭包.
    private var onSeekCompleted: () -> Void

    init(onSeekCompleted: @escaping () -> Void = {}) {
        self.onSeekCompleted = onSeekCompleted
    }

    var body: some View {
        HStack {
            Text(formatTime(streamingViewModel.currentTime))

            StyledSlider(
                value: Binding<Double>(
                    get: { streamingViewModel.seekPosition },
                    set: { streamingViewModel.seekPosition = $0 }
                ),
                in: 0...1,
                onEditingChanged: { isEditing in
                    /// 取消已有的隐藏播放控制栏的定时器.
                    streamingViewModel.hidePlaybackControlsTimer.invalidate()

                    if !isEditing {
                        /// 使用滑块拖动后的位置计算出新的当前的播放时间并修改播放进度.
                        streamingViewModel.currentTime = streamingViewModel.seekPosition
                            * streamingViewModel.totalDuration

                        streamingViewModel.resetHidePlaybackControlsTimer()
                        streamingViewModel.player.seek(
                            to: CMTime(seconds: streamingViewModel.currentTime, preferredTimescale: 1000)
                        )

                        onSeekCompleted()
                    }
            })
            .onChange(of: streamingViewModel.seekPosition, {
                guard streamingViewModel.totalDuration > 0 else {
                    return
                }

                /// 获取滑块拖动过程中, 实时的当前和剩余的播放时间.
                streamingViewModel.currentTime = streamingViewModel.seekPosition * streamingViewModel.totalDuration
                streamingViewModel.remainingTime = streamingViewModel.totalDuration - streamingViewModel.currentTime
            })

            Text(formatTime(streamingViewModel.remainingTime))
        }
        .bold()
        .font(.footnote)
        .foregroundStyle(Color.foreground)
    }

    /// 将时间格式化为`hh:mm:ss`或者`mm:ss`格式的字符串.
    ///
    /// - Parameters:
    ///   - time: 以秒为单位的时间.
    /// - Returns: 格式化后的字符串.
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)

        let hours = totalSeconds / 3600
        let minutes = totalSeconds % 3600 / 60
        let seconds = totalSeconds % 60

        return hours > 0
            ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            : String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()

    ProgressBar()
        .environment(streamingViewModel)
}
