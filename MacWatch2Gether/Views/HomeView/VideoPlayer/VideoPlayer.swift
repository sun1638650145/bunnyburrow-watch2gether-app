//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayer.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/1/14.
//

import AVKit
import AppKit
import Foundation
import SwiftUI

import SwiftyJSON

/// `VideoPlayer`是视频播放器视图, 显示视频内容并提供播放控制功能.
struct VideoPlayer: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 模态视图开关变量.
    @State private var isModalOpen: Bool = false

    /// 模态视图显示的通知信息变量.
    @State private var notificationMessage: String = ""

    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black

            VideoPlayerView(player: streamingViewModel.player)

            if streamingViewModel.showVolumeSlider {
                VolumeSlider(volume: streamingViewModel.volume)
                    .padding(10)
            }

            if streamingViewModel.showPlaybackControls {
                PlaybackControls()
                    .padding(10)
            }

            VideoPlayerModal(notificationMessage, isOpen: isModalOpen)
        }
        .onAppear(perform: {
            /// 添加滚动事件监听器用以调整音量.
            NSEvent.addLocalMonitorForEvents(matching: .scrollWheel, handler: { event in
                /// 向上滑动为负值.
                let deltaY = Float(-event.scrollingDeltaY / 200)

                withAnimation(.easeInOut, {
                    streamingViewModel.showVolumeSlider = true

                    /// 确保音量值在有效范围内.
                    streamingViewModel.volume = min(1, max(streamingViewModel.volume + deltaY, 0))
                })

                if event.phase == .ended {
                    /// 设置音量滑块在结束滚动1.5秒钟后自动关闭.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        streamingViewModel.showVolumeSlider = false
                    })
                }

                return event
            })

            /// 添加接收播放器状态同步和打开播放器模态框事件监听器给WebSocket客户端.
            webSocketClient.on(eventName: "receivePlayerSync", listener: self.receivePlayerSync(command:))
            webSocketClient.on(eventName: "openModal", listener: { command, clientID in
                self.openModal(command: command, clientID: clientID)
            })
        })
        .onDoubleTapGesture(perform: {
            /// 视频播放器进入窗口全屏状态.
            guard let window = NSApplication.shared.keyWindow
            else {
                return
            }

            /// 需要视频播放器视图和窗口状态一致时.
            if appSettings.isFullScreen == window.styleMask.contains(.fullScreen) {
                window.toggleFullScreen(nil)
            }

            appSettings.isFullScreen.toggle()
        })
        .onTapGesture(perform: {
            streamingViewModel.resetHidePlaybackControlsTimer()
            streamingViewModel.showPlaybackControls.toggle()
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
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)
    let webSocketClient = WebSocketClient()

    VideoPlayer()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(streamingViewModel)
        .environment(webSocketClient)
}
