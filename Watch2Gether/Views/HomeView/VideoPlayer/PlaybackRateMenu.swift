//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  PlaybackRateMenu.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2025/2/5.
//

import SwiftUI

/// `PlaybackRateMenu`是视频播放速率菜单, 用于显示和修改当前视频的播放速率.
struct PlaybackRateMenu: View {
    @Environment(StreamingViewModel.self) var streamingViewModel

    var body: some View {
        Menu(content: {
            // ...
        }, label: {
            Text("\(streamingViewModel.currentPlaybackRate.formattedPlaybackRate())倍")
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()

    PlaybackRateMenu()
        .environment(streamingViewModel)
}
