//
//  VideoPlayer.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import AVKit
import Foundation
import SwiftUI

import SwiftyJSON

struct VideoPlayer: View {
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 播放器进度条当前的位置.
    @State private var seekPosition: Double = 0.0
    
    /// 显示播放控制组件变量.
    @State private var showPlaybackControls: Bool = true
    
    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black
                /// 在iOS上同时忽略安全区.
                #if os(iOS)
                .ignoresSafeArea()
                #endif
            
            #if os(iOS)
            VideoPlayerViewController()
                .ignoresSafeArea(edges: .bottom)
            #elseif os(macOS)
            VideoPlayerView()
            #endif
            
            VStack {
                /// 使得播放控制栏在视图底部.
                Spacer()
                    
                if showPlaybackControls {
                    PlaybackControls(seekPosition: $seekPosition)
                        .padding(10)
                }
            }
        }
        .onAppear(perform: {
            /// 添加播放器状态同步事件监听函数给WebSocket客户端.
            websocketClient.on(
                eventName: "receivePlayerSync",
                listener: self.receivePlayerSync(command:)
            )
            
            /// 在iOS上当播放器全屏时设置视图为横屏.
            #if os(iOS)
            AppDelegate.orientationLock = (
                streamingViewModel.isFullScreen ? .landscape : .portrait
            )
            #endif
        })
        .onTapGesture(perform: {
            // TODO: 定时器无操作后自动消失(Steve).
            showPlaybackControls.toggle()
        })
    }
    
    /// 接收播放器状态同步.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func receivePlayerSync(command: JSON) {
        if let command = command.string {
            if command == "play" {
                /// 播放视频.
                /// 不使用`player.play()`, 使用修改播放速率触发播放.
                streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
            } else if command == "pause" {
                /// 暂停视频.
                streamingViewModel.player.pause()
            }
        } else if let newProgress = command["newProgress"].double {
            /// 修改播放进度.
            streamingViewModel.player.seek(
                to: CMTime(seconds: newProgress, preferredTimescale: 1000)
            )
        } else if let playbackRate = command["playbackRate"].float {
            /// 调整播放速率.
            streamingViewModel.currentPlaybackRate = playbackRate
            
            /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身为播放状态时立刻修改.
            if streamingViewModel.player.timeControlStatus == .playing {
                streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
            }
        }
    }
}

#Preview {
    let user = User(nil, "")
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    let websocketClient = WebSocketClient()
    
    VideoPlayer()
        .environment(user)
        .environment(streamingViewModel)
        .environment(websocketClient)
}
