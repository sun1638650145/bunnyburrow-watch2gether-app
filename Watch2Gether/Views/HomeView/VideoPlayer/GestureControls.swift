//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  GestureControls.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/7/26.
//

import AVKit
import Foundation
import SwiftUI

/// `GestureControls`是手势控制视图, 用于处理播放暂停, 全屏切换等多种手势交互.
struct GestureControls: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(StreamingViewModel.self) var streamingViewModel

    /// 是否正在快退.
    @State private var isRewinding: Bool = false

    /// 是否正在滑动.
    @State private var isSeeking: Bool = false

    /// 之前的播放进度(秒).
    @State private var previousProgress: Double = 0.0

    /// 显示播放进度视图变量.
    @State private var showProgressDisplay: Bool = false

    /// 滑动手势有效角度的识别范围.
    private let validAngleRange: ClosedRange<CGFloat> = 0...15

    /// 播放暂停切换时调用的闭包.
    private var onPlayPauseToggle: (Bool) -> Void

    /// 进度调整完成时调用的闭包.
    private var onSeekCompleted: () -> Void

    init(onPlayPauseToggle: @escaping (Bool) -> Void = { _ in }, onSeekCompleted: @escaping () -> Void = {}) {
        self.onPlayPauseToggle = onPlayPauseToggle
        self.onSeekCompleted = onSeekCompleted
    }

    var body: some View {
        GeometryReader(content: { geometry in
            Color.clear
                /// 设置透明的手势识别区域.
                .contentShape(Rectangle())
                .onAppear(perform: {
                    /// 初始化之前的播放进度.
                    previousProgress = streamingViewModel.currentTime
                })
                .onChange(of: streamingViewModel.currentTime, {
                    /// 未滑动时同步之前的播放进度.
                    if !isSeeking {
                        previousProgress = streamingViewModel.currentTime
                    }
                })
                .onTapGesture(perform: {
                    /// 关闭弹幕聊天消息输入视图.
                    appSettings.showDanmakuMessageInput = false

                    streamingViewModel.resetHidePlaybackControlsTimer()
                    streamingViewModel.showPlaybackControls.toggle()
                })
                .onDoubleTapGesture(perform: {
                    onPlayPauseToggle(streamingViewModel.isPlaying)

                    if streamingViewModel.isPlaying {
                        streamingViewModel.player.pause()
                    } else {
                        /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                        streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                    }
                })
                .onScaleGesture(scaleDownPerform: {
                    appSettings.isFullScreen = false
                }, scaleUpPerform: {
                    appSettings.isFullScreen = true
                })
                .onDragGesture(changedPerform: { gesture in
                    /// 计算滑动手势的角度, 在有效范围内才能调整播放进度.
                    guard validAngleRange.contains(calculateAngle(translation: gesture.translation)) else {
                        return
                    }

                    isSeeking = true

                    let deltaX = gesture.translation.width / geometry.size.width
                    /// 一次滑动手势过程中会产生多个`deltaX`, 避免累加播放进度且保证进度变化连续.
                    let newProgress = previousProgress + deltaX * streamingViewModel.totalDuration

                    /// 通过比较新进度值和当前的播放时间来判断滑动的方向, 即是否正在快退(可实现滑动过程中实时更新).
                    isRewinding = newProgress < streamingViewModel.currentTime

                    /// 确保播放进度值在有效范围内.
                    streamingViewModel.currentTime = min(streamingViewModel.totalDuration, max(newProgress, 0))
                    streamingViewModel.remainingTime = streamingViewModel.totalDuration - streamingViewModel.currentTime
                    streamingViewModel.seekPosition = streamingViewModel.currentTime / streamingViewModel.totalDuration

                    showProgressDisplay = true
                }, endedPerform: { _ in
                    // 更新之前的播放进度.
                    previousProgress = streamingViewModel.currentTime

                    streamingViewModel.player.seek(
                        to: CMTime(seconds: streamingViewModel.currentTime, preferredTimescale: 1000)
                    )

                    onSeekCompleted()

                    isSeeking = false
                    showProgressDisplay = false
                })
        })
        .overlay(content: {
            if showProgressDisplay {
                ProgressLabel(
                    currentTime: streamingViewModel.currentTime,
                    totalDuration: streamingViewModel.totalDuration,
                    isIconFlipped: isRewinding
                )
            }
        })
    }

    /// 计算滑动手势与x轴之间的夹角.
    ///
    /// - Parameters:
    ///   - translation: 滑动手势的总位移量.
    /// - Returns: 滑动手势与x轴之间的夹角.
    private func calculateAngle(translation: CGSize) -> CGFloat {
        let radians = atan2(translation.height, translation.width)
        let degrees = abs(radians * 180 / .pi)

        return degrees > 90 ? 180 - degrees : degrees
    }
}

#Preview {
    let appSettings = AppSettings()
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    GestureControls()
        .environment(appSettings)
        .environment(streamingViewModel)
}
