//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ProgressControl.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/7/23.
//

import AVKit
import Foundation
import SwiftUI

/// `ProgressControl`是播放进度控制视图, 通过水平滑动鼠标或者触控板调整视频的播放进度.
struct ProgressControl: View {
    @Environment(PlayerViewModel.self) var playerViewModel

    /// 是否正在快退.
    @State private var isRewinding: Bool = false

    /// 显示播放进度视图变量.
    @State private var showProgressDisplay: Bool = false

    /// 滑动完成时调用的闭包.
    private var onSwipeCompleted: () -> Void

    init(onSwipeCompleted: @escaping () -> Void = {}) {
        self.onSwipeCompleted = onSwipeCompleted
    }

    var body: some View {
        SwipeableView(onSwipe: { event in
            guard playerViewModel.isPlayable else {
                return
            }

            showProgressDisplay = true

            let newProgress = playerViewModel.currentTime + event.scrollingDeltaX

            /// 通过比较新进度值和当前的播放时间来判断滑动的方向, 即是否正在快退.
            isRewinding = newProgress < playerViewModel.currentTime

            /// 计算当前, 剩余的播放时间和进度条的位置.
            playerViewModel.currentTime = min(playerViewModel.totalDuration, max(newProgress, 0))
            playerViewModel.remainingTime = playerViewModel.totalDuration - playerViewModel.currentTime
            playerViewModel.seekPosition = playerViewModel.currentTime / playerViewModel.totalDuration

            playerViewModel.player.seek(to: CMTime(seconds: playerViewModel.currentTime, preferredTimescale: 1000))

            onSwipeCompleted()

            /// 设置播放进度标签1秒钟后自动关闭.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                showProgressDisplay = false
            })
        })
        .overlay(content: {
            if showProgressDisplay {
                ProgressLabel(
                    currentTime: playerViewModel.currentTime,
                    totalDuration: playerViewModel.totalDuration,
                    isIconFlipped: isRewinding
                )
            }
        })
    }
}

#Preview {
    let playerViewModel = PlayerViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    ProgressControl()
        .environment(playerViewModel)
}
