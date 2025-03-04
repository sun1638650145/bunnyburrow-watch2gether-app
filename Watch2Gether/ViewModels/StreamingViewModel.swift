//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  StreamingViewModel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import AVKit
import Combine
import Foundation
import Observation

/// 流媒体视频视图模型.
@Observable
class StreamingViewModel {
    /// 视频播放器.
    let player: AVPlayer

    /// 播放状态: 当前的播放速率.
    var currentPlaybackRate: Float = 1.0

    /// 播放状态: 当前的播放时间(秒).
    var currentTime: Double = 0.0

    /// 用于自动隐藏播放控制栏的定时器.
    var hidePlaybackControlsTimer: Timer = Timer()

    /// 播放状态: 是否正在播放.
    var isPlaying: Bool = false

    /// 播放状态: 剩余的播放时间(秒).
    var remainingTime: Double = 0.0

    /// 播放状态: 视频播放进度条当前的位置.
    var seekPosition: Double = 0.0

    /// 显示播放控制栏变量.
    var showPlaybackControls: Bool = true

    /// 播放状态: 视频的总时长(秒).
    var totalDuration: Double = 0.0

    /// 用于存储事件监听器的取消器集合.
    private var cancellables = Set<AnyCancellable>()

    /// 视频源URL.
    private var url: URL {
        didSet {
            /// 当URL被赋新值后更新播放器.
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }

    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)

        self.observePlayerStatus()
    }

    convenience init() {
        self.init(url: URL(string: "about:blank")!)
    }

    /// 重置隐藏播放控制栏的定时器.
    ///
    /// - Parameters:
    ///   - seconds: 定时器延迟的秒数, 默认为5.0秒.
    func resetHidePlaybackControlsTimer(seconds: TimeInterval = 5.0) {
        /// 取消已有的定时器.
        self.hidePlaybackControlsTimer.invalidate()

        self.hidePlaybackControlsTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            self.showPlaybackControls = false
        })
    }

    /// 更新视频源URL.
    ///
    /// - Parameters:
    ///   - newUrl: 新的视频源URL.
    func updateURL(_ newUrl: URL) {
        self.url = newUrl
    }

    /// 观察播放器的播放状态.
    private func observePlayerStatus() {
        player.addPeriodicTimeObserver(
            /// 每隔0.5秒获取一次新的播放进度.
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 100),
            queue: nil,
            using: { _ in
                guard self.totalDuration > 0 else {
                    return
                }

                /// 计算当前和剩余的播放时间.
                self.currentTime = self.player.currentTime().seconds
                self.remainingTime = self.totalDuration - self.currentTime
            }
        )

        player.publisher(for: \.currentItem)
            /// 确保`currentItem`为有效值.
            .compactMap({ $0 })

            /// 将收到的当前的视频进行处理.
            .sink(receiveValue: { item in
                item.publisher(for: \.status)
                    /// 当收到的状态为准备好播放`readyToPlay`时, 更新视频的总时长和剩余的播放时间.
                    .sink(receiveValue: { status in
                        if status == .readyToPlay {
                            self.totalDuration = item.duration.seconds
                            self.remainingTime = self.totalDuration
                        }
                    })

                    /// 将事件监听器保存到取消器集合中.
                    .store(in: &self.cancellables)
            })

            /// 将事件监听器保存到取消器集合中.
            .store(in: &cancellables)

        player.publisher(for: \.timeControlStatus)
            /// 将收到的状态传递给`isPlaying`.
            .sink(receiveValue: { status in
                self.isPlaying = (status == .playing)
            })

            /// 将事件监听器保存到取消器集合中.
            .store(in: &cancellables)
    }
}
