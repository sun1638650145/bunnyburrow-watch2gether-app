//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  PlaybackControlsCommands.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/1/21.
//

import AVKit
#if os(macOS)
import AppKit
#endif
import SwiftUI

import SwiftyJSON

/// `PlaybackControlsCommands`是自定义命令菜单, 用于实现视频播放器的播放控制.
struct PlaybackControlsCommands: Commands {
    @FocusedValue(AppSettings.self) var appSettings
    @FocusedValue(User.self) var user
    @FocusedValue(StreamingViewModel.self) var streamingViewModel
    @FocusedValue(WebSocketClient.self) var webSocketClient

    var body: some Commands {
        CommandMenu("控制", content: {
            /// 播放控制按钮.
            Button(action: {
                guard let streamingViewModel = streamingViewModel
                else {
                    return
                }

                if streamingViewModel.isPlaying {
                    streamingViewModel.player.pause()
                    sendPlayerSync(command: "pause")
                } else {
                    /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                    streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                    sendPlayerSync(command: "play")
                }
            }, label: {
                Text(streamingViewModel?.isPlaying == true ? "暂停" : "播放")
            })
            .disabled(streamingViewModel?.totalDuration ?? 0 <= 0)
            .keyboardShortcut(.return, modifiers: .command)

            /// 快退30秒按钮.
            Button(action: {
                guard let streamingViewModel = streamingViewModel
                else {
                    return
                }

                /// 确保不小于0.
                let newProgress = max(0, streamingViewModel.currentTime - 30)

                streamingViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                sendPlayerSync(command: ["newProgress": newProgress])
            }, label: {
                Text("快退30秒")
            })
            .disabled(streamingViewModel?.totalDuration ?? 0 <= 0)
            .keyboardShortcut(.leftArrow, modifiers: .shift)

            /// 快进30秒按钮.
            Button(action: {
                guard let streamingViewModel = streamingViewModel
                else {
                    return
                }

                /// 确保不超过视频总时长.
                let newProgress = min(streamingViewModel.totalDuration, streamingViewModel.currentTime + 30)

                streamingViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                sendPlayerSync(command: ["newProgress": newProgress])
            }, label: {
                Text("快进30秒")
            })
            .disabled(streamingViewModel?.totalDuration ?? 0 <= 0)
            .keyboardShortcut(.rightArrow, modifiers: .shift)

            Divider()

            /// 全屏控制按钮.
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5), {
                    /// 在macOS上视频播放器进入窗口全屏状态.
                    #if os(macOS)
                    guard let window = NSApplication.shared.keyWindow, let appSettings = appSettings
                    else {
                        return
                    }

                    /// 需要视频播放器视图和窗口状态一致时.
                    if appSettings.isFullScreen == window.styleMask.contains(.fullScreen) {
                        window.toggleFullScreen(nil)
                    }
                    #endif

                    appSettings.isFullScreen.toggle()
                })
            }, label: {
                Text(appSettings?.isFullScreen == true ? "退出全屏幕" : "进入全屏幕")
            })
            .disabled(appSettings?.isLoggedIn != true)
            .keyboardShortcut(.escape, modifiers: .command)
        })
    }

    /// 发送播放器状态同步命令.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func sendPlayerSync(command: JSON) {
        guard let user = user, let webSocketClient = webSocketClient
        else {
            return
        }

        webSocketClient.broadcast([
            "action": "player",
            "command": command,
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": user.clientID
            ]
        ])
    }
}
