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
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: streaming.url)
        
        let viewController = AVPlayerViewController()
        
        /// 设置视频播放器.
        viewController.player = player
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // ...
    }
}

#Preview {
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    VideoPlayerViewController()
        .environment(streaming)
}
