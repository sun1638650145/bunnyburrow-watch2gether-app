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
    @Environment(StreamingViewModel.self) var streamingViewModel

    var body: some View {
        ScrollableView(onScrollWheel: { event in
            /// 向上滑动为负值.
            let deltaY = Float(-event.scrollingDeltaY / 200)

            withAnimation(.easeInOut, {
                streamingViewModel.showVolumeDisplay = true

                /// 取消静音.
                streamingViewModel.isMuted = false

                /// 确保音量值在有效范围内.
                streamingViewModel.volume = min(1, max(streamingViewModel.volume + deltaY, 0))
            })

            if event.phase == .ended {
                /// 设置音量滑块在结束滚动1.5秒后自动关闭.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    streamingViewModel.showVolumeDisplay = false
                })
            }
        })
        .overlay(content: {
            if streamingViewModel.showVolumeDisplay {
                Group {
                    if streamingViewModel.isMuted {
                        MuteIndicator()
                    } else {
                        VolumeSlider(volume: streamingViewModel.volume)
                    }
                }
                .padding(10)
            }
        })
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()

    VolumeControl()
        .environment(streamingViewModel)
}
