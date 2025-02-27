//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayer.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/2.
//

import AVKit
import Foundation
import SwiftUI

import SwiftyJSON

/// `VideoPlayer`是视频播放器视图, 显示视频内容并提供播放控制功能.
struct VideoPlayer: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(User.self) var user
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 模态视图开关变量.
    @State private var isModalOpen: Bool = false

    /// 模态视图显示的通知信息变量.
    @State private var notificationMessage: String = ""

    /// 视频播放进度条当前的位置(由`VideoPlayer`管理可以避免隐藏后重新显示播放控制栏时, 进度条位置被重置).
    @State private var seekPosition: Double = 0.0

    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black
                .ignoresSafeArea()

            VideoPlayerViewController(player: streamingViewModel.player)
                .ignoresSafeArea(edges: .bottom)

            if streamingViewModel.showPlaybackControls {
                PlaybackControls(seekPosition: $seekPosition)
                    .padding(10)
            }

            VideoPlayerModal(notificationMessage, isOpen: isModalOpen)
        }
        .onAppear(perform: {
            /// 当视频播放器全屏时设置视图为横屏(仅在iPhone上有效, iPad会保持原屏幕方向).
            AppDelegate.orientationLock = appSettings.isFullScreen ? .landscape : .portrait

            /// 添加接收播放器状态同步和打开播放器模态框事件监听器给WebSocket客户端.
            webSocketClient.on(eventName: "receivePlayerSync", listener: self.receivePlayerSync(command:))
            webSocketClient.on(eventName: "openModal", listener: { command, clientID in
                self.openModal(command: command, clientID: clientID)
            })
        })
        .onTapGesture(perform: {
            streamingViewModel.resetHidePlaybackControlsTimer()
            streamingViewModel.showPlaybackControls.toggle()
        })
        .onDoubleTapGesture(perform: {
            if streamingViewModel.isPlaying {
                streamingViewModel.player.pause()
                sendPlayerSync(command: "pause")
            } else {
                /// 播放视频(不使用`player.play()`, 使用修改播放速率触发播放并更新播放速率).
                streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                sendPlayerSync(command: "play")
            }
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

    /// 发送播放器状态同步命令.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func sendPlayerSync(command: String) {
        webSocketClient.broadcast([
            "action": "player",
            "command": command,
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": user.clientID
            ]
        ])
    }

    /// 打开视频播放器模态框.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    ///   - clientID: 用户的客户端ID.
    private func openModal(command: JSON, clientID: UInt) {
        isModalOpen = true

        /// 从好友信息视图模型中获取用户信息.
        let friend = friendsViewModel.searchFriend(by: clientID)!

        if let command = command.string {
            if command == "play" {
                notificationMessage = "用户\(friend.name)播放了当前内容."
            } else if command == "pause" {
                notificationMessage = "用户\(friend.name)暂停了当前内容."
            }
        } else if command["newProgress"].double != nil {
            notificationMessage = "用户\(friend.name)修改了播放进度."
        } else if command["playbackRate"].float != nil {
            notificationMessage = "用户\(friend.name)修改了播放速率."
        }

        /// 设置模态框1秒钟后自动关闭.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            isModalOpen = false
        })
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let webSocketClient = WebSocketClient()

    VideoPlayer()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(streamingViewModel)
        .environment(webSocketClient)
}
