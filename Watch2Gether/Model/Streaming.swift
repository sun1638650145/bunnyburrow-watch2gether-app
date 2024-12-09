//
//  Streaming.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/23.
//

import AVKit
import Foundation
import Observation

/// 流媒体视频.
@Observable
class Streaming {
    /// 视频播放器.
    let player: AVPlayer
    
    /// 播放状态: 当前的播放速率.
    var currentPlaybackRate: Float = 1.0
    
    /// 播放状态: 当前的播放时间.
    var currentTime: Double = 0.0
    
    /// 播放状态: 剩余的播放时间.
    var remainingTime: Double = 0.0
    
    /// 视频源URL.
    private var url: URL {
        didSet {
            /// 当URL被赋新值后更新播放器.
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }
    
    init(url: URL) {
        self.url = url
        self.player = AVPlayer()
    }
    
    /// 更新视频源URL.
    ///
    /// - Parameters:
    ///   - newUrl: 新的视频源URL.
    func updateURL(_ newUrl: URL) {
        self.url = newUrl
    }
}
