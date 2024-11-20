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
    /// 视频源URL.
    var url: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        
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
    VideoPlayerViewController(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
}
