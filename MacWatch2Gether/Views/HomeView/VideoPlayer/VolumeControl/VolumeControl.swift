//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VolumeControl.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/3/13.
//

import SwiftUI

/// `VolumeControl`是音量控制视图, 通过滚动事件调整播放器的音频音量.
struct VolumeControl: View {
    @Environment(PlayerViewModel.self) var playerViewModel

    var body: some View {
        ScrollableView(onScrollWheel: { event in
            /// 向上滑动为负值.
            let deltaY = Float(-event.scrollingDeltaY / 200)

            /// 检测到滚动变化量不为0时.
            if deltaY != 0 {
                withAnimation(.easeInOut, {
                    playerViewModel.showVolumeDisplay = true

                    /// 取消静音.
                    playerViewModel.isMuted = false

                    /// 确保音量值在有效范围内.
                    playerViewModel.volume = min(1, max(playerViewModel.volume + deltaY, 0))
                })
            }

            if event.phase == .ended {
                /// 设置音量滑块在结束滚动1.5秒后自动关闭.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    playerViewModel.showVolumeDisplay = false
                })
            }
        })
        .overlay(content: {
            if playerViewModel.showVolumeDisplay {
                Group {
                    if playerViewModel.isMuted {
                        MuteIndicator()
                    } else {
                        VolumeSlider(volume: playerViewModel.volume)
                    }
                }
                .padding(15)
            }
        })
    }
}

#Preview {
    let playerViewModel = PlayerViewModel()

    VolumeControl()
        .environment(playerViewModel)
}
