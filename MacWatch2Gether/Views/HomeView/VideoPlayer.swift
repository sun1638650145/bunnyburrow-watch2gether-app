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
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 当前的播放速率.
    @State private var currentPlaybackRate: Float = 1.0
    
    /// `AVPlayer`播放器加载并控制视频播放.
    let player: AVPlayer
    
    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black
            
            VideoPlayerView(player: player)
        }
        .onAppear(perform: {
            /// 添加播放器状态同步事件监听函数给WebSocket客户端.
            websocketClient.on(
                eventName: "receivePlayerSync",
                listener: self.receivePlayerSync(command:)
            )
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
            
            /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身为播放状态时立刻播放.
            if player.timeControlStatus == .playing {
                player.rate = currentPlaybackRate
            }
        }
    }
}

#Preview {
    let websocketClient = WebSocketClient()
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)
    
    VideoPlayer(player: player)
        .environment(websocketClient)
}
