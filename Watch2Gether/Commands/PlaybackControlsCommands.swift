//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
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

/// `PlaybackControlsCommands`是自定义命令菜单, 用于实现视频播放器的播放控制.
struct PlaybackControlsCommands: Commands {
    @FocusedValue(AppSettings.self) private var appSettings
    @FocusedValue(User.self) private var user
    @FocusedValue(PlayerViewModel.self) private var playerViewModel
    @FocusedValue(WebSocketClient.self) private var webSocketClient

    var body: some Commands {
        CommandMenu("Controls", content: {
            Group {
                /// 播放控制按钮.
                Button(action: {
                    guard let playerViewModel = playerViewModel, let webSocketClient = webSocketClient
                    else {
                        return
                    }

                    if playerViewModel.isPlaying {
                        playerViewModel.player.pause()
                        webSocketClient.sendPlayerSync(command: "pause")
                    } else {
                        /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                        playerViewModel.player.rate = playerViewModel.currentPlaybackRate
                        webSocketClient.sendPlayerSync(command: "play")
                    }
                }, label: {
                    Text(playerViewModel?.isPlaying == true ? "Pause" : "Play")
                })
                .keyboardShortcut(.return, modifiers: .command)

                /// 快退30秒按钮.
                Button(action: {
                    guard let playerViewModel = playerViewModel, let webSocketClient = webSocketClient
                    else {
                        return
                    }

                    /// 确保不小于0.
                    let newProgress = max(0, playerViewModel.currentTime - 30)

                    playerViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                    webSocketClient.sendPlayerSync(command: ["newProgress": newProgress])
                }, label: {
                    Text("Skip Back 30s")
                })
                .keyboardShortcut("A", modifiers: [.command, .shift])

                /// 快进30秒按钮.
                Button(action: {
                    guard let playerViewModel = playerViewModel, let webSocketClient = webSocketClient
                    else {
                        return
                    }

                    /// 确保不超过视频总时长.
                    let newProgress = min(playerViewModel.totalDuration, playerViewModel.currentTime + 30)

                    playerViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                    webSocketClient.sendPlayerSync(command: ["newProgress": newProgress])
                }, label: {
                    Text("Skip Ahead 30s")
                })
                .keyboardShortcut("D", modifiers: [.command, .shift])
            }
            .disabled(playerViewModel?.totalDuration ?? 0 <= 0)

            Divider()

            /// 静音控制按钮.
            Button(action: {
                guard let playerViewModel = playerViewModel
                else {
                    return
                }

                playerViewModel.showVolumeDisplay = true
                playerViewModel.resetHideVolumeDisplayTimer()

                playerViewModel.isMuted.toggle()
            }, label: {
                Text(playerViewModel?.isMuted == true ? "Unmute" : "Mute")
            })
            .keyboardShortcut("M", modifiers: [.command, .shift])

            /// 增加音量按钮.
            Button(action: {
                guard let playerViewModel = playerViewModel
                else {
                    return
                }

                playerViewModel.showVolumeDisplay = true
                playerViewModel.resetHideVolumeDisplayTimer()

                /// 取消静音并增加10%的音量.
                playerViewModel.isMuted = false
                playerViewModel.volume = min(playerViewModel.volume + 0.1, 1)
            }, label: {
                Text("Volume Up")
            })
            .disabled(playerViewModel?.volume ?? 0 >= 1)
            .keyboardShortcut("W", modifiers: [.command, .shift])

            /// 减少音量按钮.
            Button(action: {
                guard let playerViewModel = playerViewModel
                else {
                    return
                }

                playerViewModel.showVolumeDisplay = true
                playerViewModel.resetHideVolumeDisplayTimer()

                /// 取消静音并减少10%的音量.
                playerViewModel.isMuted = false
                playerViewModel.volume = max(0, playerViewModel.volume - 0.1)
            }, label: {
                Text("Volume Down")
            })
            .disabled(playerViewModel?.volume ?? 0 <= 0)
            .keyboardShortcut("S", modifiers: [.command, .shift])

            Divider()

            /// 全屏控制按钮.
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5), {
                    guard let appSettings = appSettings
                    else {
                        return
                    }

                    /// 在macOS上视频播放器进入窗口全屏状态.
                    #if os(macOS)
                    guard let window = NSApplication.shared.keyWindow
                    else {
                        return
                    }

                    /// 需要视频播放器视图和窗口状态一致时.
                    if appSettings.isPlayerFullScreen == appSettings.isWindowFullScreen {
                        window.toggleFullScreen(nil)
                    }
                    #endif

                    appSettings.isPlayerFullScreen.toggle()
                })
            }, label: {
                Text(appSettings?.isPlayerFullScreen == true ? "Exit Full Screen" : "Full Screen")
            })
            .disabled(appSettings?.isLoggedIn != true)
            .keyboardShortcut(.escape, modifiers: .command)
        })
    }
}
