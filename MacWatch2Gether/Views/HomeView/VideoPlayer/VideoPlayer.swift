//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayer.swift
//  MacWatch2Gether
//
//  Create by Steve R. Sun on 2025/1/14.
//

import AVKit
import Foundation
import SwiftUI

import SwiftyJSON

/// `VideoPlayer`是视频播放器视图, 显示视频内容并提供播放控制功能.
struct VideoPlayer: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 视频播放进度条当前的位置(由`VideoPlayer`管理可以避免隐藏后重新显示播放控制栏时, 进度条位置被重置).
    @State private var seekPosition: Double = 0.0

    /// 显示播放控制栏变量.
    @State private var showPlaybackControls: Bool = true

    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black

            VideoPlayerView(player: streamingViewModel.player)

            if showPlaybackControls {
                PlaybackControls(seekPosition: $seekPosition)
                    .padding(10)
            }
        }
        .onAppear(perform: {
            /// 添加播放器状态同步事件监听器给WebSocket客户端.
            webSocketClient.on(eventName: "receivePlayerSync", listener: self.receivePlayerSync(command:))
        })
        .onTapGesture(perform: {
            // TODO: 定时器无操作后自动消失(Steve).
            showPlaybackControls.toggle()
        })
    }

    /// 接收播放器状态同步命令.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func receivePlayerSync(command: JSON) {
        if let command = command.string {
            if command == "play" {
                /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
            } else if command == "pause" {
                /// 暂停视频.
                streamingViewModel.player.pause()
            }
        } else if let newProgress = command["newProgress"].double {
            /// 修改播放进度.
            streamingViewModel.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
        } else if let playbackRate = command["playbackRate"].float {
            /// 调整播放速率.
            streamingViewModel.currentPlaybackRate = playbackRate

            /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身正在播放时直接修改播放速率.
            if streamingViewModel.isPlaying {
                streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
            }
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)
    let webSocketClient = WebSocketClient()

    VideoPlayer()
        .environment(appSettings)
        .environment(user)
        .environment(streamingViewModel)
        .environment(webSocketClient)
}
