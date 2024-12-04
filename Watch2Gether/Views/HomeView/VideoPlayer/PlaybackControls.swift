//
//  PlaybackControls.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/4.
//

import AVKit
import Foundation
import SwiftUI

struct PlaybackControls: View {
    @Binding var isPlaying: Bool
    @Environment(User.self) var user
    @Environment(WebSocketClient.self) var websocketClient
    
    /// `AVPlayer`播放器加载并控制视频播放.
    let player: AVPlayer
    
    init(player: AVPlayer, isPlaying: Binding<Bool>) {
        self.player = player
        self._isPlaying = isPlaying
    }
    
    var body: some View {
        Button(action: {
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            
            /// 设置播放状态.
            isPlaying.toggle()
            
            sendPlayerSync(command: isPlaying ? "play": "pause")
        }, label: {
            Image(systemName: isPlaying ? "pause.fill": "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(hex: "#F9F9F9"))
        })
    }
    
    /// 发送播放器状态同步.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func sendPlayerSync(command: String) {
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

    PlaybackControls(player: player, isPlaying: .constant(false))
        .environment(user)
        .environment(websocketClient)
}
