//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  VideoSwitchButton.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/9/5.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

/// `VideoSwitchButton`是视频源切换按钮;
/// 当视频播放器使用本地视频文件时会打开`NSOpenPanel`,
/// 当视频播放器使用流媒体视频源时会请求流媒体视频列表并打开`VideoSwitcher`.
struct VideoSwitchButton: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(VideosViewModel.self) var videosViewModel

    var body: some View {
        Button(action: {
            /// 使用本地视频文件则打开`NSOpenPanel`.
            if playerViewModel.domainUrl.isFileURL {
                appSettings.isPanelActive = true
                present()
                appSettings.isPanelActive = false
            } else {
                playerViewModel.showPlaybackControls = false
                playerViewModel.showVideoSwitcher = true

                Task(operation: {
                    do {
                        try await videosViewModel.fetchVideos(from: playerViewModel.domainUrl)
                    } catch {
                        print("获取流媒体视频列表失败: \(error.localizedDescription)")
                    }
                })
            }
        }, label: {
            Image(systemName: "film.stack")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 27, height: 27)
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
        .buttonStyle(PlainButtonStyle())
    }

    /// 展示`NSOpenPanel`允许用户切换视频.
    private func present() {
        let openPanel = NSOpenPanel()

        /// 目前允许用户选择MPEG-2和MPEG-4格式的视频.
        openPanel.allowedContentTypes = [.mpeg2TransportStream, .mpeg4Movie]

        /// 作为模态窗口展示.
        let response = openPanel.runModal()

        /// 使用主线程执行, 提高稳定性.
        DispatchQueue.main.async(execute: {
            if response == .OK {
                if let url = openPanel.url {
                    /// 切换视频.
                    playerViewModel.updateURL(url)
                }
            }
        })
    }
}

#Preview {
    let appSettings = AppSettings()
    let playerViewModel = PlayerViewModel()
    let videosViewModel = VideosViewModel()

    VideoSwitchButton()
        .environment(appSettings)
        .environment(playerViewModel)
        .environment(videosViewModel)
}
