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

    var body: some View {
        VStack {
            if videosViewModel.videos.isEmpty {
                Text("Loading...")
            } else {
                ForEach(videosViewModel.videos, id: \.self, content: { video in
                    Button(action: {
                        playerViewModel.showVideoSwitcher = false
                        playerViewModel.switchTo(named: video)
                    }, label: {
                        Text(video)
                    })
                    .buttonStyle(PlainButtonStyle())
                })
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
