//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  PlaybackControls.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/4.
//

import AVKit
#if os(macOS)
import AppKit
#endif
import Foundation
import SwiftUI

/// `PlaybackControls`是播放控制栏视图, 用于显示播放进度条和播放控制按钮.
struct PlaybackControls: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(User.self) var user
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(VideosViewModel.self) var videosViewModel
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
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.foreground)
                            .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                    })

                    Spacer()
                }
            }

            /// 使得播放控制栏在视图底部.
            Spacer()

            ProgressBar(onSeekCompleted: {
                webSocketClient.sendPlayerSync(command: ["newProgress": playerViewModel.currentTime])
            })

            HStack {
                /// 快退30秒按钮.
                Button(action: {
                    /// 确保不小于0.
                    let newProgress = max(0, playerViewModel.currentTime - 30)

                    playerViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                    playerViewModel.resetHidePlaybackControlsTimer()

                    webSocketClient.sendPlayerSync(command: ["newProgress": newProgress])
                }, label: {
                    Image(systemName: "30.arrow.trianglehead.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
                })

                /// 播放控制按钮.
                Button(action: {
                    playerViewModel.resetHidePlaybackControlsTimer()

                    if playerViewModel.isPlaying {
                        playerViewModel.player.pause()
                        webSocketClient.sendPlayerSync(command: "pause")
                    } else {
                        /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                        playerViewModel.player.rate = playerViewModel.currentPlaybackRate
                        webSocketClient.sendPlayerSync(command: "play")
                    }
                }, label: {
                    Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
                })

                /// 快进30秒按钮.
                Button(action: {
                    guard playerViewModel.totalDuration > 0 else {
                        return
                    }

                    /// 确保不超过视频总时长.
                    let newProgress = min(playerViewModel.totalDuration, playerViewModel.currentTime + 30)

                    playerViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
                    playerViewModel.resetHidePlaybackControlsTimer()

                    webSocketClient.sendPlayerSync(command: ["newProgress": newProgress])
                }, label: {
                    Image(systemName: "30.arrow.trianglehead.clockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
                })

                Spacer()

                /// 播放速率菜单.
                PlaybackRateMenu(playbackRates: [0.5, 0.75, 1, 1.25, 1.5, 2], onPlaybackChange: { newRate in
                    webSocketClient.sendPlayerSync(command: ["playbackRate": newRate])
                })

                /// 切换视频按钮.
                Button(action: {
                    playerViewModel.showVideoSwitcher = true

                    Task(operation: {
                        do {
                            try await videosViewModel.fetchVideos(from: playerViewModel.domainUrl)
                        } catch {
                            print("获取流媒体视频列表失败: \(error.localizedDescription)")
                        }
                    })
                }, label: {
                    Image(systemName: "film.stack")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 27, height: 27)
                        .foregroundStyle(Color.foreground)
                        .padding(5)
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
                    .frame(width: 22, height: 22)
                    .foregroundStyle(Color.foreground)
                    .padding(5)
                })
            }
        }
        #if os(macOS)
        .buttonStyle(PlainButtonStyle())
        #endif
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let playerViewModel = PlayerViewModel(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let videosViewModel = VideosViewModel()
    let webSocketClient = WebSocketClient()

    PlaybackControls()
        .environment(user)
        .environment(appSettings)
        .environment(playerViewModel)
        .environment(videosViewModel)
        .environment(webSocketClient)
}
