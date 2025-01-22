//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayerView.swift
//  MacWatch2Gether
//
//  Create by Steve R. Sun on 2024/11/11.
//

import AVKit
import AppKit
import Foundation
import SwiftUI

/// `VideoPlayerView`是基于`NSViewRepresentable`实现的视频播放视图, 它提供视频播放的功能.
struct VideoPlayerView: NSViewRepresentable {
    /// 视频播放器.
    let player: AVPlayer

    func makeNSView(context: Context) -> NSView {
        let playerLayer = AVPlayerLayer(player: player)

        let view = NSView()

        /// 将`AVPlayerLayer`设置为`NSView`的图层.
        view.layer = playerLayer

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // ...
    }
}

#Preview {
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)

    VideoPlayerView(player: player)
}
