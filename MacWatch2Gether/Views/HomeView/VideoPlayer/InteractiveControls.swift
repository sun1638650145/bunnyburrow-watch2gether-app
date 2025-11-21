//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  InteractiveControls.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/7/28.
//

import AppKit
import Foundation
import SwiftUI

/// `InteractiveControls`是交互控制视图, 用于处理鼠标和触控板的交互.
///
/// 支持以下交互操作:
///   - **单击鼠标或触控板**: 关闭弹幕聊天消息输入视图和切换显示播放控制栏.
///   - **双击鼠标或触控板**: 切换全屏状态.
///   - **水平滑动鼠标或触控板**: 调整视频的播放进度.
///   - **垂直滑动触控板或滚动鼠标滚轮**: 调整播放器的音频音量.
struct InteractiveControls: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(PlayerViewModel.self) var playerViewModel

    /// 水平滑动完成时调用的闭包.
    private var onSwipeCompleted: () -> Void

    init(onSwipeCompleted: @escaping () -> Void = {}) {
        self.onSwipeCompleted = onSwipeCompleted
    }

    var body: some View {
        Group {
            ProgressControl(onSwipeCompleted: onSwipeCompleted)

            VolumeControl()
        }
        .onDoubleTapGesture(perform: {
            /// 视频播放器进入窗口全屏状态.
            guard let window = NSApplication.shared.keyWindow
            else {
                return
            }

            /// 需要视频播放器视图和窗口状态一致时.
            if appSettings.isPlayerFullScreen == appSettings.isWindowFullScreen {
                window.toggleFullScreen(nil)
            }

            appSettings.isPlayerFullScreen.toggle()
        })
        .onTapGesture(perform: {
            /// 关闭弹幕聊天消息输入视图.
            appSettings.showDanmakuMessageInput = false

            playerViewModel.resetHidePlaybackControlsTimer()
            playerViewModel.showPlaybackControls.toggle()
        })
    }
}

#Preview {
    let appSetting = AppSettings()
    let playerViewModel = PlayerViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    InteractiveControls()
        .environment(appSetting)
        .environment(playerViewModel)
}
