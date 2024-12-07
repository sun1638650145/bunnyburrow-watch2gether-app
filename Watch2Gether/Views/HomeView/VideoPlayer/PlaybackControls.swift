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
            
            ProgressBar(
                player: player,
                currentTime: $currentTime,
                seekPosition: $seekPosition,
                totalDuration: player.currentItem?.duration.seconds,
                onSeekCompleted: {
                    sendPlayerSync(command: [
                        "newProgress": currentTime
                    ])
                }
            )
        }
        .onAppear(perform: {
            observePlayerStatus()
        })
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
