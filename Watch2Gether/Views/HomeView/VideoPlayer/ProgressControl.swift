//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ProgressControl.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/7/18.
//

import AVKit
import Foundation
import SwiftUI

/// `ProgressControl`是播放进度控制视图, 通过水平滑动手势调整视频的播放进度.
struct ProgressControl: View {
    @Environment(StreamingViewModel.self) var streamingViewModel

    /// 是否正在滑动.
    @State private var isDragging: Bool = false

    /// 之前的播放进度(秒).
    @State private var previousProgress: Double = 0.0

    /// 显示播放进度视图变量.
    @State private var showProgressDisplay: Bool = false

    /// 滑动手势有效角度的识别范围.
    private let validAngleRange: ClosedRange<CGFloat> = 0...15

    var body: some View {
        GeometryReader(content: { geometry in
            Color.clear
                /// 设置透明的手势识别区域.
                .contentShape(Rectangle())
                .onAppear(perform: {
                    /// 初始化之前的播放进度.
                    previousProgress = streamingViewModel.currentTime
                })
                .onChange(of: streamingViewModel.currentTime, {
                    /// 未滑动时同步之前的播放进度.
                    if !isDragging {
                        previousProgress = streamingViewModel.currentTime
                    }
                })
                .onDragGesture(changedPerform: { gesture in
                    /// 计算滑动手势的角度, 在有效范围内才能调整播放进度.
                    guard validAngleRange.contains(calculateAngle(translation: gesture.translation)) else {
                        return
                    }

                    isDragging = true

                    let deltaX = gesture.translation.width / geometry.size.width
                    /// 一次滑动手势过程中会产生多个`deltaX`, 避免累加播放进度且保证进度变化连续.
                    let newProgress = previousProgress + deltaX * streamingViewModel.totalDuration

                    /// 确保播放进度值在有效范围内.
                    streamingViewModel.currentTime = min(streamingViewModel.totalDuration, max(newProgress, 0))
                    streamingViewModel.remainingTime = streamingViewModel.totalDuration - streamingViewModel.currentTime
                    streamingViewModel.seekPosition = streamingViewModel.currentTime / streamingViewModel.totalDuration

                    showProgressDisplay = true
                }, endedPerform: { _ in
                    /// 更新之前的播放进度.
                    previousProgress = streamingViewModel.currentTime

                    streamingViewModel.player.seek(
                        to: CMTime(seconds: streamingViewModel.currentTime, preferredTimescale: 1000)
                    )

                    isDragging = false
                    showProgressDisplay = false
                })
        })
        .overlay(content: {
            if showProgressDisplay {
                Text(formatTime(streamingViewModel.currentTime) + "/" + formatTime(streamingViewModel.totalDuration))
                    .font(.headline)
                    .foregroundStyle(Color.foreground)
            }
        })
    }

    /// 计算滑动手势与水平轴之间的夹角.
    ///
    /// - Parameters:
    ///   - translation: 滑动手势的总位移量.
    /// - Returns: 滑动手势与水平轴之间的夹角.
    private func calculateAngle(translation: CGSize) -> CGFloat {
        let radians = atan2(translation.height, translation.width)
        let degress = abs(radians * 180 / .pi)

        return degress > 90 ? 180 - degress : degress
    }

    /// 将时间格式化为`hh:mm:ss`或者`mm:ss`格式的字符串.
    ///
    /// - Parameters:
    ///   - time: 以秒为单位的时间.
    /// - Returns: 格式化后的字符串.
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)

        let hours = totalSeconds / 3600
        let minutes = totalSeconds % 3600 / 60
        let seconds = totalSeconds % 60

        return hours > 0
            ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            : String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)

    ProgressControl()
        .environment(streamingViewModel)
}
