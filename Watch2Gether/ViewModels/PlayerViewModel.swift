//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  PlayerViewModel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import AVKit
import Combine
import Foundation
import MediaPlayer
import Observation

/// 流媒体播放器视图模型.
@Observable
class PlayerViewModel {
    /// 视频播放器.
    let player: AVPlayer

    /// 播放状态: 当前的播放速率.
    var currentPlaybackRate: Float = 1.0

    /// 播放状态: 当前的播放时间(秒).
    var currentTime: Double = 0.0

    /// 当前播放的视频名称.
    var currentVideoName: String {
        /// 使用视频源URL的最后一个路径组成作为视频名称.
        return url.lastPathComponent
    }

    /// 视频源域名URL.
    var domainUrl: URL {
        return url.domainURL ?? url
    }

    /// 用于自动隐藏播放控制栏的定时器.
    var hidePlaybackControlsTimer: Timer = Timer()

    /// 播放状态: 是否静音.
    var isMuted: Bool = false {
        didSet {
            /// 同步更新视频播放器的静音状态.
            player.isMuted = isMuted
        }
    }

    /// 播放状态: 是否准备好播放.
    var isPlayable: Bool = false

    /// 播放状态: 是否正在播放.
    var isPlaying: Bool = false {
        didSet {
            #if os(macOS)
            if isPlaying {
                sleepAssertionManager.preventSleep(with: "视频正在播放")
            } else {
                sleepAssertionManager.enableSleep()
            }
            #endif
        }
    }

    /// 播放状态: 剩余的播放时间(秒).
    var remainingTime: Double = 0.0

    /// 播放状态: 视频播放进度条当前的位置.
    var seekPosition: Double = 0.0

    /// 显示播放控制栏变量.
    var showPlaybackControls: Bool = true

    /// 显示视频切换视图变量.
    var showVideoSwitcher: Bool = false

    /// 显示音量相关视图变量.
    var showVolumeDisplay: Bool = false

    /// 播放状态: 视频的总时长(秒).
    var totalDuration: Double = 0.0

    /// 播放状态: 音频音量, 范围从0.0(静音)到1.0(最大音量).
    var volume: Float = 0.5 {
        didSet {
            /// 同步更新视频播放器的音量.
            player.volume = volume
        }
    }

    /// 用于存储事件监听器的取消器集合.
    private var cancellables = Set<AnyCancellable>()

    /// 用于自动隐藏音量相关视图的定时器.
    private var hideVolumeDisplayTimer: Timer = Timer()

    /// 安全域资源管理器.
    private var securityScopedResourceManager = SecurityScopedResourceManager()

    /// 系统休眠状态管理器.
    #if os(macOS)
    private var sleepAssertionManager = SleepAssertionManager()
    #endif

    /// 视频源URL.
    private var url: URL {
        didSet {
            let url = securityScopedResourceManager.startAccessing(for: url)

            /// 当URL被赋新值后更新播放器.
            player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }

    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)

        /// 初始化视频播放器的音量.
        self.player.volume = self.volume

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

    /// 重置隐藏音量滑块的定时器.
    ///
    /// - Parameters:
    ///   - seconds: 定时器延迟的秒数, 默认为1.5秒.
    func resetHideVolumeDisplayTimer(seconds: TimeInterval = 1.5) {
        /// 取消已有的定时器.
        self.hideVolumeDisplayTimer.invalidate()

        self.hideVolumeDisplayTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            self.showVolumeDisplay = false
        })
    }

    /// 切换到指定名称的视频源.
    ///
    /// - Parameters:
    ///   - video: 视频名称.
    func switchTo(named video: String) {
        guard var urlComponents = URLComponents(url: self.url, resolvingAgainstBaseURL: false) else {
            return
        }

        /// 更新路径, 拼接指定视频名称.
        urlComponents.path = "/video/\(video)/"

        if let newUrl = urlComponents.url {
            updateURL(newUrl)
        }
    }

    /// 更新视频源URL.
    ///
    /// - Parameters:
    ///   - newUrl: 新的视频源URL.
    func updateURL(_ newUrl: URL) {
        /// 当视频源URL与视频源域名URL一致时, 则跳过更新`UserDefaults`.
        if self.url != self.domainUrl {
            let decodedString = newUrl.absoluteString.removingPercentEncoding ?? newUrl.absoluteString
            UserDefaults.standard.set(decodedString, forKey: "Server.url")
        }

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

                /// 计算当前, 剩余的播放时间和进度条的位置.
                self.currentTime = self.player.currentTime().seconds
                self.remainingTime = self.totalDuration - self.currentTime
                self.seekPosition = self.currentTime / self.totalDuration

                /// 更新锁屏界面和控制中心的正在播放信息.
                self.setupNowPlayingInfo()
            }
        )

        player.publisher(for: \.currentItem)
            /// 确保`currentItem`为有效值.
            .compactMap({ $0 })

            /// 将收到的当前的视频进行处理.
            .sink(receiveValue: { item in
                item.publisher(for: \.status)
                    /// 当收到的状态为准备好播放`readyToPlay`时, 标记播放器已准备好播放, 并更新视频的总时长和剩余的播放时间.
                    .sink(receiveValue: { status in
                        if status == .readyToPlay {
                            self.isPlayable = true
                            self.totalDuration = item.duration.seconds
                            self.remainingTime = self.totalDuration
                        } else if status == .failed {
                            if let error = item.error {
                                print("应用初始化或播放失败: \(error.localizedDescription)")
                            }
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

    /// 配置并更新锁屏界面和控制中心的正在播放信息.
    private func setupNowPlayingInfo() {
        let nowPlayingInfo: [String: Any] = [
            /// 使用应用名称作为艺术家.
            MPMediaItemPropertyArtist: Bundle.main.infoDictionary!["CFBundleDisplayName"]!,
            MPMediaItemPropertyTitle: currentVideoName,
            MPMediaItemPropertyPlaybackDuration: totalDuration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
