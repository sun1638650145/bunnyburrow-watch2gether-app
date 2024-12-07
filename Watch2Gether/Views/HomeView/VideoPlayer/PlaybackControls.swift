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
    @Binding var seekPosition: Double
    @Environment(User.self) var user
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 当前的播放时间.
    @State private var currentTime: Double = 0.0
        
    /// 视频是否播放状态变量.
    @State private var isPlaying: Bool = false
    
    /// 播放器状态变化监听器的取消器.
    @State private var playerStatusCancellable: AnyCancellable?
    
    /// `AVPlayer`播放器加载并控制视频播放.
    let player: AVPlayer
    
    init(player: AVPlayer, seekPosition: Binding<Double>) {
        self.player = player
        self._seekPosition = seekPosition
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
            
            HStack {
                Text(formatTime(currentTime))
                    .bold()
                    .font(.footnote)
                    .foregroundStyle(Color(hex: "#F9F9F9"))
                
                Slider(value: $seekPosition, in: 0...1, onEditingChanged: { isEditing in
                    if !isEditing {
                        /// 修改播放进度.
                        player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000))

                        sendPlayerSync(command: [
                            "newProgress": currentTime
                        ])
                    }
                })
                /// 实时更新显示的当前播放时间.
                .onChange(of: seekPosition, {
                    /// 获取当前播放的视频.
                    guard let currentVideo = player.currentItem
                    else {
                        return
                    }
                    
                    /// 根据当前位置和视频总时长计算修改后的时间.
                    currentTime = seekPosition * currentVideo.duration.seconds
                })
                .tint(Color(hex: "#F9F9F9"))
                
                Text(formatTime(player.currentItem?.duration.seconds))
                    .bold()
                    .font(.footnote)
                    .foregroundStyle(Color(hex: "#F9F9F9"))
            }
        }
        .onAppear(perform: {
            observePlayerProgress()
            observePlayerStatus()
        })
    }
    
    /// 格式化时间.
    private func formatTime(_ time: Double?) -> String {
        guard let time = time, !time.isNaN
        else {
            /// 如果时间无效则返回`--:--`.
            return "--:--"
        }
        
        let totalSeconds = Int(time)
        
        let hours = totalSeconds / 3600
        let minutes = totalSeconds % 3600 / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// 观察播放器的播放进度.
    private func observePlayerProgress() {
        player.addPeriodicTimeObserver(
            /// 每隔0.5秒获取一次新的播放进度.
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000),
            queue: nil,
            using: { _ in
                /// 获取当前播放的视频.
                guard let currentVideo = player.currentItem
                else {
                    return
                }
                
                /// 计算新的进度条位置.
                if currentVideo.duration.isNumeric {
                    let currentTime = player.currentTime().seconds
                    seekPosition = currentTime / currentVideo.duration.seconds
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
    @Previewable @State var seekPosition: Double = 0.0
    
    let user = User(nil, "")
    let websocketClient = WebSocketClient()
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    PlaybackControls(player: player, seekPosition: $seekPosition)
        .environment(user)
        .environment(websocketClient)
}
