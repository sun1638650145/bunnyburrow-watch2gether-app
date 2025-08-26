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

/// `VideoSwitcher`是视频切换菜单, 用于在多个视频之间进行切换.
struct VideoSwitcher: View {
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(VideosViewModel.self) var videosViewModel

    var body: some View {
        Menu(content: {
            if videosViewModel.videos.isEmpty {
                Text("Loading...")
            } else {
                ForEach(videosViewModel.videos, id: \.self, content: { video in
                    Button(action: {
                        streamingViewModel.switchTo(named: video)
                    }, label: {
                        Text(video)
                    })
                })
            }
        }, label: {
            Text("Switch Video")
                .bold()
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
        .task({
            do {
                try await videosViewModel.fetchVideos(from: streamingViewModel.domainUrl)
            } catch {
                print("获取流媒体视频列表失败: \(error.localizedDescription)")
            }
        })
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()
    let videosViewModel = VideosViewModel()

    VideoSwitcher()
        .environment(streamingViewModel)
        .environment(videosViewModel)
}
