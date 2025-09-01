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
    @Environment(PlayerViewModel.self) var playerViewModel

    /// 进度调整完成时调用的闭包.
    private var onSeekCompleted: () -> Void

    init(onSeekCompleted: @escaping () -> Void = {}) {
        self.onSeekCompleted = onSeekCompleted
    }

    var body: some View {
        HStack {
            Text(playerViewModel.currentTime.formattedTime())

            StyledSlider(
                value: Binding<Double>(
                    get: { playerViewModel.seekPosition },
                    set: { playerViewModel.seekPosition = $0 }
                ),
                in: 0...1,
                onEditingChanged: { isEditing in
                    /// 取消已有的隐藏播放控制栏的定时器.
                    playerViewModel.hidePlaybackControlsTimer.invalidate()

                    if !isEditing {
                        /// 使用滑块拖动后的位置计算出新的当前的播放时间并修改播放进度.
                        playerViewModel.currentTime = playerViewModel.seekPosition * playerViewModel.totalDuration

                        playerViewModel.resetHidePlaybackControlsTimer()
                        playerViewModel.player.seek(
                            to: CMTime(seconds: playerViewModel.currentTime, preferredTimescale: 1000)
                        )

                        onSeekCompleted()
                    }
            })
            .onChange(of: playerViewModel.seekPosition, {
                guard playerViewModel.totalDuration > 0 else {
                    return
                }

                /// 获取滑块拖动过程中, 实时的当前和剩余的播放时间.
                playerViewModel.currentTime = playerViewModel.seekPosition * playerViewModel.totalDuration
                playerViewModel.remainingTime = playerViewModel.totalDuration - playerViewModel.currentTime
            })

            Text(playerViewModel.remainingTime.formattedTime())
        }
        .bold()
        .font(.footnote)
        .foregroundStyle(Color.foreground)
    }
}

#Preview {
    let playerViewModel = PlayerViewModel()

    ProgressBar()
        .environment(playerViewModel)
}
