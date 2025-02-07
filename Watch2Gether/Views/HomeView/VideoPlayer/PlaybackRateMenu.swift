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

    /// 播放速率调整后调用的闭包.
    private var onPlaybackChange: ((Float) -> Void)?

    /// 可供选择的播放速率.
    private let playbackRates: [Float]

    init(playbackRates: [Float], onPlaybackChange: ((Float) -> Void)? = nil) {
        self.playbackRates = playbackRates
        self.onPlaybackChange = onPlaybackChange
    }

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

                    onPlaybackChange?(rate)
                }, label: {
                    Text("\(rate.formattedPlaybackRate())倍")
                })
                .disabled(rate == streamingViewModel.currentPlaybackRate)
            })
        }, label: {
            Text("\(streamingViewModel.currentPlaybackRate.formattedPlaybackRate())倍")
                .bold()
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()

    PlaybackRateMenu(playbackRates: [0.5, 1, 2])
        .environment(streamingViewModel)
}
