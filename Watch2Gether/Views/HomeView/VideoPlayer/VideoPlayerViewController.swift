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
    @Environment(StreamingViewModel.self) var streamingViewModel
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        
        /// 设置视频播放器.
        viewController.player = streamingViewModel.player
        
        /// 隐藏默认的播放控制组件.
        viewController.showsPlaybackControls = false
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // ...
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    
    VideoPlayerViewController()
        .environment(streamingViewModel)
}
