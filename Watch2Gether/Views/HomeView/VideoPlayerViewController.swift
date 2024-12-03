//
//  VideoPlayerViewController.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import AVKit
import Foundation
import SwiftUI

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
        private func receivePlayerSync(command: String) {
            if command == "play" {
                /// 播放视频.
                player.play()
            } else if command == "pause" {
                /// 暂停视频.
                player.pause()
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
