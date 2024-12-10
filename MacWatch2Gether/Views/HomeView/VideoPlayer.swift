//
//  VideoPlayer.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/20.
//

import AVKit
import Foundation
import SwiftUI

import SwiftyJSON

struct VideoPlayer: View {
    @Binding var isFullScreen: Bool
    @Environment(Streaming.self) var streaming
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 播放器进度条当前的位置.
    @State private var seekPosition: Double = 0.0
    
    /// 显示播放控制组件变量.
    @State private var showPlaybackControls: Bool = true
    
    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black
            
            VideoPlayerView()
            
            VStack {
                /// 使得播放控制栏在视图底部.
                Spacer()
                
                if showPlaybackControls {
                    PlaybackControls(seekPosition: $seekPosition, isFullScreen: $isFullScreen)
                        .padding(15)
                }
            }
        }
        .onAppear(perform: {
            /// 添加播放器状态同步事件监听函数给WebSocket客户端.
            websocketClient.on(
                eventName: "receivePlayerSync",
                listener: self.receivePlayerSync(command:)
            )
        })
        .onTapGesture(perform: {
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
                streaming.player.rate = streaming.currentPlaybackRate
            } else if command == "pause" {
                /// 暂停视频.
                streaming.player.pause()
            }
        } else if let newProgress = command["newProgress"].double {
            /// 修改播放进度.
            streaming.player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
        } else if let playbackRate = command["playbackRate"].float {
            /// 调整播放速率.
            streaming.currentPlaybackRate = playbackRate
            
            /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身为播放状态时立刻修改.
            if streaming.player.timeControlStatus == .playing {
                streaming.player.rate = streaming.currentPlaybackRate
            }
        }
    }
}

#Preview {
    let user = User(nil, "")
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let websocketClient = WebSocketClient()
    
    VideoPlayer(isFullScreen: .constant(false))
        .environment(user)
        .environment(streaming)
        .environment(websocketClient)
}
