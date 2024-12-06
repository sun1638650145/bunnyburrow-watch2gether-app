//
//  PlaybackControls.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/4.
//

import AVKit
import Combine
import Foundation
import SwiftUI

import SwiftyJSON

struct PlaybackControls: View {
    @Environment(User.self) var user
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 播放器状态变化监听器的取消器.
    @State private var playerStatusCancellable: AnyCancellable?
    
    /// 视频是否播放状态变量.
    @State private var isPlaying: Bool = false
    
    /// 播放器进度条当前的位置.
    @State private var seekPosition: Double = 0.0
    
    /// `AVPlayer`播放器加载并控制视频播放.
    let player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    var body: some View {
        HStack {
            Button(action: {
                if isPlaying {
                    player.pause()
                    sendPlayerSync(command: "pause")
                } else {
                    player.play()
                    sendPlayerSync(command: "play")
                }
            }, label: {
                Image(systemName: isPlaying ? "pause.fill": "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: "#F9F9F9"))
            })
            
            Slider(value: $seekPosition, in: 0...1, onEditingChanged: { _ in
                /// 获取当前播放的视频.
                guard let currentVideo = player.currentItem
                else {
                    return
                }
                
                /// 根据当前位置和视频总时长计算修改后的时间.
                let currentTime = seekPosition * currentVideo.duration.seconds
                
                /// 修改播放进度.
                player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000))
                
                sendPlayerSync(command: [
                    "newProgress": currentTime
                ])
            })
        }
        .onAppear(perform: {
            observePlayerProgress()
            observePlayerStatus()
        })
    }
    
    /// 观察播放器的播放进度.
    private func observePlayerProgress() {
        player.addPeriodicTimeObserver(
            /// 每隔0.5秒获取一次新的播放进度.
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000),
            queue: nil,
            using: { time in
                /// 获取当前播放的视频.
                guard let currentVideo = player.currentItem
                else {
                    return
                }
                
                /// 计算新的进度条位置.
                if currentVideo.duration.isNumeric {
                    seekPosition = time.seconds / currentVideo.duration.seconds
                }
            }
        )
    }
    
    /// 观察播放器的播放状态.
    private func observePlayerStatus() {
        playerStatusCancellable = player.publisher(for: \.timeControlStatus)
            /// 将收到的状态传递给`isPlaying`.
            .sink(receiveValue: { status in
                isPlaying = (status == .playing)
            })
    }
    
    /// 发送播放器状态同步.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func sendPlayerSync(command: JSON) {
        websocketClient.broadcast([
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
    let user = User(nil, "")
    let websocketClient = WebSocketClient()
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    PlaybackControls(player: player)
        .environment(user)
        .environment(websocketClient)
}
