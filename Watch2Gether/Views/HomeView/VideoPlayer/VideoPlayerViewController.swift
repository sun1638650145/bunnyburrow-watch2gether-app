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
    /// `AVPlayer`播放器加载并控制视频播放.
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        
        /// 设置视频播放器.
        viewController.player = self.player
        
        /// 隐藏默认的播放控制组件.
        viewController.showsPlaybackControls = false
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // ...
    }
}

#Preview {
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    VideoPlayerViewController(player: player)
}
