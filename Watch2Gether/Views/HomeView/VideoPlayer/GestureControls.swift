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

    /// 是否正在调整音量.
    @State private var isAdjustingVolume: Bool = false

    /// 是否正在长按.
    @State private var isLongPressing: Bool = false

    /// 是否正在快退.
    @State private var isRewinding: Bool = false

    /// 是否正在滑动.
    @State private var isSeeking: Bool = false

    /// 之前的播放速率.
    @State private var previousPlaybackRate: Float = 1.0

    /// 之前的播放进度(秒).
    @State private var previousProgress: Double = 0.0

    /// 之前的音频音量.
    @State private var previousVolume: Float = 0.0

    /// 显示播放进度视图变量.
    @State private var showProgressDisplay: Bool = false

    /// 水平滑动手势有效角度的识别范围.
    private let validHorizontalAngleRange: ClosedRange<CGFloat> = 0...15

    /// 垂直滑动手势有效角度的识别范围.
    private let validVerticalAngleRange: ClosedRange<CGFloat> = 75...90

    /// 播放速率调整后调用的闭包.
    private var onPlaybackRateChange: () -> Void

    /// 播放暂停切换时调用的闭包.
    private var onPlayPauseToggle: (Bool) -> Void

    /// 进度调整完成时调用的闭包.
    private var onSeekCompleted: () -> Void

    init(
        onPlayPauseToggle: @escaping (Bool) -> Void = { _ in },
        onPlaybackRateChange: @escaping () -> Void = {},
        onSeekCompleted: @escaping () -> Void = {}
    ) {
        self.onPlayPauseToggle = onPlayPauseToggle
        self.onPlaybackRateChange = onPlaybackRateChange
        self.onSeekCompleted = onSeekCompleted
    }

    var body: some View {
        GeometryReader(content: { geometry in
            Color.clear
                /// 设置透明的手势识别区域.
                .contentShape(Rectangle())
                .onAppear(perform: {
                    /// 初始化之前的播放进度和音频音量.
                    previousProgress = streamingViewModel.currentTime
                    previousVolume = streamingViewModel.volume
                })
                .onChange(of: streamingViewModel.currentTime, {
                    /// 未滑动时同步之前的播放进度.
                    if !isSeeking {
                        previousProgress = streamingViewModel.currentTime
                    }
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
                .onLongPressGesture(perform: {
                    /// 当视频正在播放时, 长按2倍速播放.
                    guard streamingViewModel.isPlaying else {
                        return
                    }

                    isLongPressing = true

                    /// 记录之前的播放速率.
                    previousPlaybackRate = streamingViewModel.currentPlaybackRate

                    streamingViewModel.currentPlaybackRate = 2.0
                    streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                    onPlaybackRateChange()
                }, onPressingChanged: { isPressing in
                    if !isPressing {
                        /// 松开长按手势时, 恢复原播放速率.
                        if isLongPressing {
                            streamingViewModel.currentPlaybackRate = previousPlaybackRate
                            streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                            onPlaybackRateChange()
                        }

                        isLongPressing = false
                    }
                })
                .onDragGesture(changedPerform: { gesture in
                    let angle = calculateAngle(translation: gesture.translation)

                    /// 计算水平滑动手势的角度, 在有效范围内才能调整播放进度.
                    if validHorizontalAngleRange.contains(angle) {
                        handleHorizontalDragGesture(gesture: gesture, geometry: geometry)
                    /// 计算垂直滑动手势的角度, 在有效范围内才能调整音量.
                    } else if validVerticalAngleRange.contains(angle) {
                        /// 只在右侧1/2的屏幕生效.
                        guard gesture.startLocation.x > geometry.size.width / 2 else {
                            return
                        }

                        handleVerticalDragGesture(gesture: gesture, geometry: geometry)
                    }
                }, endedPerform: { _ in
                    if isSeeking {
                        /// 更新之前的播放进度.
                        previousProgress = streamingViewModel.currentTime

                        streamingViewModel.player.seek(
                            to: CMTime(seconds: streamingViewModel.currentTime, preferredTimescale: 1000)
                        )

                        onSeekCompleted()

                        isSeeking = false
                        showProgressDisplay = false
                    } else if isAdjustingVolume {
                        /// 更新之前的音频音量.
                        previousVolume = streamingViewModel.volume

                        /// 设置音量滑块在结束滑动1.5秒钟后自动关闭.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            streamingViewModel.showVolumeDisplay = false
                        })

                        isAdjustingVolume = false
                    }
                })
                .onScaleGesture(scaleDownPerform: {
                    appSettings.isFullScreen = false
                }, scaleUpPerform: {
                    appSettings.isFullScreen = true
                })
                .onTapGesture(perform: {
                    /// 关闭弹幕聊天消息输入视图.
                    appSettings.showDanmakuMessageInput = false

                    streamingViewModel.resetHidePlaybackControlsTimer()
                    streamingViewModel.showPlaybackControls.toggle()
                })
        })
        .overlay(content: {
            if showProgressDisplay {
                ProgressLabel(
                    currentTime: streamingViewModel.currentTime,
                    totalDuration: streamingViewModel.totalDuration,
                    isIconFlipped: isRewinding
                )
            } else if isLongPressing {
                FastPlaybackIndicator()
                    .padding(15)
            } else if streamingViewModel.showVolumeDisplay {
                Group {
                    if streamingViewModel.isMuted {
                        MuteIndicator()
                    } else {
                        VolumeSlider(volume: streamingViewModel.volume)
                    }
                }
                .padding(15)
            }
        })
    }

    /// 计算滑动手势的角度.
    ///
    /// - Parameters:
    ///   - translation: 滑动手势的总位移量.
    /// - Returns: 滑动手势的角度.
    private func calculateAngle(translation: CGSize) -> CGFloat {
        let radians = atan2(abs(translation.height), abs(translation.width))
        let degrees = radians * 180 / .pi

        return degrees
    }

    /// 处理水平滑动手势.
    ///
    /// - Parameters:
    ///   - gesture: 滑动手势的属性.
    ///   - geometry: 当前容器视图的大小和空间信息的代理.
    private func handleHorizontalDragGesture(gesture: DragGesture.Value, geometry: GeometryProxy) {
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
    }

    /// 处理垂直滑动手势.
    ///
    /// - Parameters:
    ///   - gesture: 滑动手势的属性.
    ///   - geometry: 当前容器视图的大小和空间信息的代理.
    private func handleVerticalDragGesture(gesture: DragGesture.Value, geometry: GeometryProxy) {
        isAdjustingVolume = true

        /// 向上滑动为负值.
        let deltaY = Float(-gesture.translation.height / geometry.size.height)

        /// 一次滑动手势过程中会产生多个`deltaY`, 避免累加音量且保证音量变化连续.
        let newVolume = previousVolume + deltaY

        withAnimation(.easeInOut, {
            streamingViewModel.showVolumeDisplay = true

            /// 取消静音.
            streamingViewModel.isMuted = false

            /// 确保音量值在有效范围内.
            streamingViewModel.volume = min(1, max(newVolume, 0))
        })
    }
}

#Preview {
    let appSettings = AppSettings()
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    GestureControls()
        .environment(appSettings)
        .environment(streamingViewModel)
}
