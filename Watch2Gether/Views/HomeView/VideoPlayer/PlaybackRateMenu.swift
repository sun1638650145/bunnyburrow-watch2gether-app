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

    /// 可供选择的播放速率.
    private let playbackRates: [Float] = [0.5, 0.75, 1, 1.25, 1.5, 2]

    var body: some View {
        Menu(content: {
            ForEach(playbackRates, id: \.self, content: { rate in
                Button(action: {
                    /// 调整播放速率.
                    streamingViewModel.currentPlaybackRate = rate

                    /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身正在播放时直接修改播放速率.
                    if streamingViewModel.isPlaying {
                        streamingViewModel.player.rate = streamingViewModel.currentPlaybackRate
                    }
                }, label: {
                    Text("\(rate.formattedPlaybackRate())倍")
                })
                .disabled(streamingViewModel.currentPlaybackRate == rate)
            })
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
