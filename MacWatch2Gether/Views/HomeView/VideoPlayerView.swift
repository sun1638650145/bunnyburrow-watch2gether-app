//
//  VideoPlayerView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import AVKit
import AppKit
import Foundation
import SwiftUI

struct VideoPlayerView: NSViewRepresentable {
    /// `AVPlayer`播放器加载并控制视频播放.
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
    let player = AVPlayer(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)
    
    VideoPlayerView(player: player)
}
