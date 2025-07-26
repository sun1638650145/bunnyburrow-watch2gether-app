//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  GestureControls.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/7/26.
//

import Foundation
import SwiftUI

/// `GestureControls`是手势控制视图, 用于处理播放暂停, 全屏切换等多种手势交互.
struct GestureControls: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(StreamingViewModel.self) var streamingViewModel

    /// 播放暂停切换时调用的闭包.
    private var onPlayPauseToggle: (Bool) -> Void

    init(onPlayPauseToggle: @escaping (Bool) -> Void = { _ in }) {
        self.onPlayPauseToggle = onPlayPauseToggle
    }

    var body: some View {
        Color.clear
            /// 设置透明的手势识别区域.
            .contentShape(Rectangle())
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
    }
}

#Preview {
    let appSettings = AppSettings()
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    GestureControls()
        .environment(appSettings)
        .environment(streamingViewModel)
}
