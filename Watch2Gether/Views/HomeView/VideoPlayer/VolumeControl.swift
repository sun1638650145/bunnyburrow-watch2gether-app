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

    var body: some View {
        GeometryReader(content: { geometry in
            HStack {
                Spacer()

                Color.clear
                    /// 设置透明的手势识别区域.
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width / 2)
                    .gesture(DragGesture().onEnded({ gesture in
                        /// 向上滑动为负值.
                        let deltaY = Float(-gesture.translation.height / geometry.size.height)

                        withAnimation(.easeInOut, {
                            /// 确保音量值在有效范围内.
                            streamingViewModel.volume = min(1, max(streamingViewModel.volume + deltaY, 0))
                        })
                    }))
            }
        })
        .overlay(content: {
            VolumeSlider(volume: streamingViewModel.volume)
                .padding(10)
        })
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()

    VolumeControl()
        .environment(streamingViewModel)
}
