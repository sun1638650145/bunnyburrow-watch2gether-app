//
//  VideoPlayerViewController.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import AVKit
import Foundation
import SwiftUI

import SwiftyJSON

struct VideoPlayerViewController: UIViewControllerRepresentable {
    @Environment(Streaming.self) var streaming
    @Environment(WebSocketClient.self) var websocketClient
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        
        /// 设置视频播放器.
        viewController.player = context.coordinator.player
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // ...
    }
    
    class Coordinator: NSObject {
        /// `AVPlayer`播放器加载并控制视频播放.
        var player: AVPlayer
        
        /// 当前的播放速率.
        private var currentPlaybackRate: Float = 1.0
        
        /// WebSocket客户端.
        private var websocketClient: WebSocketClient
        
        init(_ streaming: Streaming, _ websocketClient: WebSocketClient) {
            self.player = AVPlayer(url: streaming.url)
            self.websocketClient = websocketClient
            
            /// 调用父类初始化器.
            super.init()
            
            self.websocketClient.on(
                eventName: "receivePlayerSync",
                listener: receivePlayerSync(command:)
            )
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(streaming, websocketClient)
    }
}

#Preview {
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let websocketClient = WebSocketClient()
    
    VideoPlayerViewController()
        .environment(streaming)
        .environment(websocketClient)
}
