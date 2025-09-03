//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoSwitcher.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/8/23.
//

import Foundation
import SwiftUI

import SwiftyJSON

/// `VideoSwitcher`是视频切换视图, 用于视频播放器在多个视频之间进行切换.
struct VideoSwitcher: View {
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(VideosViewModel.self) var videosViewModel

    /// 切换视频时调用的闭包.
    private var onSwitchVideo: (String) -> Void

    init(onSwitchVideo: @escaping (String) -> Void = { _ in }) {
        self.onSwitchVideo = onSwitchVideo
    }

    var body: some View {
        VStack {
            if videosViewModel.videos.isEmpty {
                VStack {
                    Text("Loading...")
                        .padding(12)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(.callout)
                        .foregroundStyle(Color.foreground)

                    Spacer()
                }
            } else {
                ScrollView(content: {
                    ForEach(videosViewModel.videos.indices, id: \.self, content: { index in
                        let video = videosViewModel.videos[index]
                        let isCurrentVideo = (video == playerViewModel.currentVideoName)

                        Button(action: {
                            playerViewModel.showVideoSwitcher = false

                            /// 不是当前播放的视频才能切换.
                            if !isCurrentVideo {
                                playerViewModel.switchTo(named: video)
                                onSwitchVideo(video)
                            }
                        }, label: {
                            Text(video)
                                .bold()
                                .foregroundStyle(Color.foreground.opacity(isCurrentVideo ? 0.5 : 1))
                                /// 使文本填满父容器, 以确保整个区域都可触发按钮.
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        })
                        #if os(macOS)
                        .buttonStyle(PlainButtonStyle())
                        #endif

                        /// 最后一行不添加分割线.
                        if index < videosViewModel.videos.count - 1 {
                            Divider()
                        }
                    })
                })
                .background(Color.black.gradient.opacity(0.3))
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    let playerViewModel = PlayerViewModel()
    let videosViewModel = VideosViewModel()

    VideoSwitcher()
        .environment(playerViewModel)
        .environment(videosViewModel)
}
