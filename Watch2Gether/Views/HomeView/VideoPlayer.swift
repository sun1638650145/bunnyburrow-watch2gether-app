//
//  VideoPlayer.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import AVKit
import Foundation
import SwiftUI

/// `VideoPlayer`是一个通用视频播放器;
/// 在iOS上使用`AVPlayerViewController`,
/// 在macOS上使用`AVPlayer`和`AVPlayerLayer`.
#if os(iOS)
struct VideoPlayer: UIViewControllerRepresentable {
    /// 视频源url.
    let url: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let viewController = AVPlayerViewController()
        
        /// 设置播放器.
        viewController.player = player
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // ...
    }
}
#elseif os(macOS)
struct VideoPlayer: NSViewRepresentable {
    /// 视频源url.
    let url: URL
    
    func makeNSView(context: Context) -> NSView {
        let player = AVPlayer(url: url)
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
#endif

#Preview {
    let url = URL(string: "http://127.0.0.1:8000/video/flower/")
    
    return VideoPlayer(url: url!)
}
