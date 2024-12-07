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
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 当前的播放速率.
    @State private var currentPlaybackRate: Float = 1.0
    
    /// 播放器进度条当前的位置.
    @State private var seekPosition: Double = 0.0
    
    /// 显示播放控制组件变量.
    @State private var showPlaybackControls: Bool = true
    
    /// `AVPlayer`播放器加载并控制视频播放.
    let player: AVPlayer
    
    var body: some View {
        ZStack {
            /// 忽略顶部安全区使得视频播放器有更好的一体性.
            Color.black
                .ignoresSafeArea(edges: .top)
            
            VideoPlayerViewController(player: player)
            
            VStack {
                /// 使得播放控制栏在视图底部.
                Spacer()
                    
                if showPlaybackControls {
                    PlaybackControls(player: player, seekPosition: $seekPosition)
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
                player.rate = currentPlaybackRate
            } else if command == "pause" {
                /// 暂停视频.
                player.pause()
            }
        } else if let newProgress = command["newProgress"].double {
            /// 修改播放进度.
            player.seek(to: CMTime(seconds: newProgress, preferredTimescale: 1000))
        } else if let playbackRate = command["playbackRate"].float {
            /// 调整播放速率.
            currentPlaybackRate = playbackRate
            
            /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身为播放状态时立刻修改.
            if player.timeControlStatus == .playing {
                player.rate = currentPlaybackRate
            }
        }
    }
}

#Preview {
    let user = User(nil, "")
    let websocketClient = WebSocketClient()
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    VideoPlayer(player: player)
        .environment(user)
        .environment(websocketClient)
}
