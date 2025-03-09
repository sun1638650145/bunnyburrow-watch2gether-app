//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VolumeControl.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/7.
//

import SwiftUI

/// `VolumeControl`是音量控制视图, 通过滑动手势调整播放器的音频音量.
struct VolumeControl: View {
    @Environment(StreamingViewModel.self) var streamingViewModel

    /// 之前的音频音量.
    @State private var previousVolume: Float = 0.5

    var body: some View {
        GeometryReader(content: { geometry in
            HStack {
                Spacer()

                Color.clear
                    /// 设置透明的手势识别区域.
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width / 2)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                /// 向上滑动为负值.
                                let deltaY = Float(-gesture.translation.height / geometry.size.height)

                                /// 一次滑动手势过程中会产生多个`deltaY`, 避免累加音量且保证音量变化连续.
                                let newVolume = previousVolume + deltaY

                                withAnimation(.easeInOut, {
                                    streamingViewModel.showVolumeSlider = true

                                    /// 确保音量值在有效范围内.
                                    streamingViewModel.volume = min(1, max(newVolume, 0))
                                })
                            })
                            .onEnded({ _ in
                                /// 更新之前的音频音量.
                                previousVolume = streamingViewModel.volume

                                /// 设置音量滑块在结束滑动1.5秒钟后自动关闭.
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                    streamingViewModel.showVolumeSlider = false
                                })
                            })
                    )
            }
        })
        .overlay(content: {
            if streamingViewModel.showVolumeSlider {
                VolumeSlider(volume: streamingViewModel.volume)
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
