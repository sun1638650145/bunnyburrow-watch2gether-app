//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VolumeAndPlaybackRateControl.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/7.
//

import SwiftUI

/// `VolumeAndPlaybackRateControl`是音量和播放速率控制视图,
/// 通过滑动手势调整播放器的音频音量, 通过长按手势以2倍速播放视频.
struct VolumeAndPlaybackRateControl: View {
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 识别到长按手势变量.
    @State private var isLongPressed: Bool = false

    /// 长按手势前的播放速率.
    @State private var playbackRateBeforeLongPress: Float = 1.0

    /// 之前的音频音量.
    @State private var previousVolume: Float = 0.0

    /// 滑动手势有效角度的识别范围.
    private let validAngleRange: ClosedRange<CGFloat> = 75...105

    var body: some View {
        GeometryReader(content: { geometry in
            HStack {
                Spacer()

                Color.clear
                    /// 设置透明的手势识别区域.
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width / 2)
                    .onAppear(perform: {
                        /// 设置当前的音频音量.
                        previousVolume = streamingViewModel.volume
                    })
                    .onLongPressGesture(perform: {
                        /// 当视频正在播放时, 长按2倍速播放.
                        guard streamingViewModel.isPlaying else {
                            return
                        }

                        /// 标记识别到长按手势.
                        isLongPressed = true

                        /// 记录长按手势前的播放速率.
                        playbackRateBeforeLongPress = streamingViewModel.currentPlaybackRate

                        streamingViewModel.currentPlaybackRate = 2.0
                        streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                        webSocketClient.sendPlayerSync(
                            command: ["playbackRate": streamingViewModel.currentPlaybackRate]
                        )
                    }, onPressingChanged: { isPressing in
                        if !isPressing {
                            /// 松开长按手势时, 恢复原播放速率.
                            if isLongPressed {
                                streamingViewModel.currentPlaybackRate = playbackRateBeforeLongPress
                                streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                                webSocketClient.sendPlayerSync(
                                    command: ["playbackRate": streamingViewModel.currentPlaybackRate]
                                )
                            }

                            /// 重置识别到长按手势变量.
                            isLongPressed = false
                        }
                    })
                    .onDragGesture(changedPerform: { gesture in
                        /// 计算滑动手势的角度, 在有效范围内才能调整音量.
                        guard validAngleRange.contains(calculateAngle(translation: gesture.translation)) else {
                            return
                        }

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
                    }, endedPerform: { _ in
                        /// 更新之前的音频音量.
                        previousVolume = streamingViewModel.volume

                        /// 设置音量滑块在结束滑动1.5秒钟后自动关闭.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            streamingViewModel.showVolumeDisplay = false
                        })
                    })
            }
        })
        .overlay(content: {
            if isLongPressed {
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
    /// - Returns: 滑动手势角度的绝对值.
    private func calculateAngle(translation: CGSize) -> CGFloat {
        let radians = atan2(translation.height, translation.width)
        let degrees = radians * 180 / .pi

        return abs(degrees)
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()
    let webSocketClient = WebSocketClient()

    VolumeAndPlaybackRateControl()
        .environment(streamingViewModel)
        .environment(webSocketClient)
}
