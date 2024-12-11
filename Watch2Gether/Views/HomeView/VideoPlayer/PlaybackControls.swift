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
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 视频是否播放状态变量.
    @State private var isPlaying: Bool = false
    
    /// 播放器状态变化监听器的取消器.
    @State private var playerStatusCancellable: AnyCancellable?
    
    var body: some View {
        HStack {
            Button(action: {
                if isPlaying {
                    streamingViewModel.player.pause()
                    sendPlayerSync(command: "pause")
                } else {
                    streamingViewModel.player.play()
                    sendPlayerSync(command: "play")
                }
            }, label: {
                Image(systemName: isPlaying ? "pause.fill": "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(hex: "#F9F9F9"))
            })
            #if os(macOS)
            .buttonStyle(PlainButtonStyle())
            #endif
            
            ProgressBar(seekPosition: $seekPosition, onSeekCompleted: {
                sendPlayerSync(command: [
                    "newProgress": streamingViewModel.currentTime
                ])
            })
            
            Button(action: {
                withAnimation(.easeOut(duration: 0.5), {
                    streamingViewModel.isFullScreen.toggle()
                })
            }, label: {
                Image(
                    systemName: streamingViewModel.isFullScreen
                    ? "arrow.down.right.and.arrow.up.left"
                    : "arrow.up.left.and.arrow.down.right"
                )
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 18, height: 18)
                .foregroundStyle(Color(hex: "#F9F9F9"))
            })
            #if os(macOS)
            .buttonStyle(PlainButtonStyle())
            #endif
        }
        .onAppear(perform: {
            observePlayerStatus()
        })
    }
    
    /// 观察播放器的播放状态.
    private func observePlayerStatus() {
        playerStatusCancellable = streamingViewModel.player.publisher(for: \.timeControlStatus)
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
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    let websocketClient = WebSocketClient()
    
    PlaybackControls(seekPosition: $seekPosition)
        .environment(user)
        .environment(streamingViewModel)
        .environment(websocketClient)
}
