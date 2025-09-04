//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoSwitchButton.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/9/4.
//

import Foundation
import SwiftUI

/// `VideoSwitchButton`是视频源切换按钮;
/// 当视频播放器使用本地视频文件时会打开`VideoPickerViewController`,
/// 当视频播放器使用流媒体视频源时会请求流媒体视频列表并打开`VideoSwitcher`.
struct VideoSwitchButton: View {
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(VideosViewModel.self) var videosViewModel

    /// 是否呈现`VideoPickerViewController`.
    @State private var isPresented: Bool = false

    /// 视频源URL.
    @State private var url: String?

    var body: some View {
        Button(action: {
            /// 使用本地视频文件则打开`VideoPickerViewController`.
            if playerViewModel.domainUrl.isFileURL {
                isPresented = true
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
        .sheet(isPresented: $isPresented, onDismiss: {
            playerViewModel.updateURL(URL(string: url!)!)
        }, content: {
            VideoPickerViewController(selectedVideo: $url)
        })
    }
}

#Preview {
    let playViewModel = PlayerViewModel()
    let videosViewModel = VideosViewModel()

    VideoSwitchButton()
        .environment(playViewModel)
        .environment(videosViewModel)
}
