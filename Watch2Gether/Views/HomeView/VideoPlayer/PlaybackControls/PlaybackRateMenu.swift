//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  PlaybackRateMenu.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/5.
//

import SwiftUI

/// `PlaybackRateMenu`是视频播放速率菜单, 用于显示和修改当前视频的播放速率.
struct PlaybackRateMenu: View {
    @Environment(PlayerViewModel.self) var playerViewModel

    /// 播放速率调整后调用的闭包.
    private var onPlaybackRateChange: (Float) -> Void

    /// 可供选择的播放速率.
    private let playbackRates: [Float]

    init(playbackRates: [Float], onPlaybackChange: @escaping (Float) -> Void = { _ in }) {
        self.playbackRates = playbackRates
        self.onPlaybackRateChange = onPlaybackChange
    }

    var body: some View {
        Menu(content: {
            ForEach(playbackRates, id: \.self, content: { rate in
                Button(action: {
                    /// 调整播放速率.
                    playerViewModel.currentPlaybackRate = rate

                    /// 修改播放速率会导致播放器立刻播放, 所以只能在播放器本身正在播放时直接修改播放速率.
                    if playerViewModel.isPlaying {
                        playerViewModel.player.rate = playerViewModel.currentPlaybackRate
                    }

                    playerViewModel.resetHidePlaybackControlsTimer()
                    onPlaybackRateChange(rate)
                }, label: {
                    Text("\(rate.formattedPlaybackRate())×")
                })
                .disabled(rate == playerViewModel.currentPlaybackRate)
            })
        }, label: {
            Text("\(playerViewModel.currentPlaybackRate.formattedPlaybackRate())×")
                .bold()
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
    }
}

#Preview {
    let playerViewModel = PlayerViewModel()

    PlaybackRateMenu(playbackRates: [0.5, 1, 2])
        .environment(playerViewModel)
}
