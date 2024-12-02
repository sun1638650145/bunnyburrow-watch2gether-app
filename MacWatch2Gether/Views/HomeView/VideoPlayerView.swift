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
    @Environment(Streaming.self) var streaming
    
    func makeNSView(context: Context) -> NSView {
        let player = AVPlayer(url: streaming.url)
        
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
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    VideoPlayerView()
        .environment(streaming)
}
