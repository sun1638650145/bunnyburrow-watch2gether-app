//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  PlaybackControls.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/12/4.
//

import AVKit
#if os(macOS)
import AppKit
#endif
import Combine
import Foundation
import SwiftUI

import SwiftyJSON

/// `PlaybackControls`是播放控制栏视图, 用于显示播放进度条和播放控制按钮.
struct PlaybackControls: View {
    @Binding var seekPosition: Double
    @Environment(AppSettings.self) var appSettings
    @Environment(User.self) var user
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    var body: some View {
        VStack {
            if appSettings.isFullScreen {
                HStack {
                    /// 退出视频播放器全屏按钮.
                    Button(action: {
                        appSettings.isFullScreen = false
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 17, height: 17)
                            .foregroundStyle(Color.foreground)
                            .padding(10)
                    })

                    Spacer()
                }
            }

            /// 使得播放控制栏在视图底部.
            Spacer()

            ProgressBar(seekPosition: $seekPosition, onSeekCompleted: {
                sendPlayerSync(command: ["newProgress": streamingViewModel.currentTime])
            })

            HStack {
                /// 快退30秒按钮.
                Button(action: {
                    /// 确保不小于0.
                    let newProgress = max(0, streamingViewModel.currentTime - 30)

                    streamingViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                    streamingViewModel.resetHidePlaybackControlsTimer()

                    sendPlayerSync(command: ["newProgress": newProgress])
                }, label: {
                    Image(systemName: "30.arrow.trianglehead.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
                })

                /// 播放控制按钮.
                Button(action: {
                    streamingViewModel.resetHidePlaybackControlsTimer()

                    if streamingViewModel.isPlaying {
                        streamingViewModel.player.pause()
                        sendPlayerSync(command: "pause")
                    } else {
                        /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                        streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                        sendPlayerSync(command: "play")
                    }
                }, label: {
                    Image(systemName: streamingViewModel.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
                })

                /// 快进30秒按钮.
                Button(action: {
                    guard streamingViewModel.totalDuration > 0 else {
                        return
                    }

                    /// 确保不超过视频总时长.
                    let newProgress = min(streamingViewModel.totalDuration, streamingViewModel.currentTime + 30)

                    streamingViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                    streamingViewModel.resetHidePlaybackControlsTimer()

                    sendPlayerSync(command: ["newProgress": newProgress])
                }, label: {
                    Image(systemName: "30.arrow.trianglehead.clockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
                })

                Spacer()

                /// 播放速率菜单.
                PlaybackRateMenu(playbackRates: [0.5, 0.75, 1, 1.25, 1.5, 2], onPlaybackChange: { newRate in
                    sendPlayerSync(command: ["playbackRate": newRate])
                })

                /// 全屏控制按钮.
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5), {
                        /// 在macOS上视频播放器进入窗口全屏状态.
                        #if os(macOS)
                        guard let window = NSApplication.shared.keyWindow
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
                    Image(
                        systemName: appSettings.isFullScreen
                        ? "arrow.down.forward.and.arrow.up.backward.rectangle"
                        : "arrow.up.backward.and.arrow.down.forward.rectangle"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.foreground)
                    .padding(5)
                })
            }
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        #endif
    }

    /// 发送播放器状态同步命令.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func sendPlayerSync(command: JSON) {
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

#Preview {
    @Previewable @State var seekPosition: Double = 0.0

    let appSettings = AppSettings()
    let user = User()
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let webSocketClient = WebSocketClient()

    PlaybackControls(seekPosition: $seekPosition)
        .environment(user)
        .environment(appSettings)
        .environment(streamingViewModel)
        .environment(webSocketClient)
}
