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
    @Environment(StreamingViewModel.self) var streamingViewModel
    
    func makeNSView(context: Context) -> NSView {
        let playerLayer = AVPlayerLayer(player: streamingViewModel.player)
        
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
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    
    VideoPlayerView()
        .environment(streamingViewModel)
}
