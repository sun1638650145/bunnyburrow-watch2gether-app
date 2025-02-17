//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayerViewController.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import AVKit
import Foundation
import SwiftUI

/// `VideoPlayerViewController`是使用`AVPlayerViewController`实现的视频播放视图控制器, 它提供视频播放的功能.
struct VideoPlayerViewController: UIViewControllerRepresentable {
    /// 视频播放器.
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()

        /// 设置视频播放器.
        viewController.player = player

        /// 禁用实况文本(Live Text).
        viewController.allowsVideoFrameAnalysis = false

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
