//
//  ProgressBar.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/7.
//

import AVKit
import SwiftUI

struct ProgressBar: View {
    @Binding var seekPosition: Double
    @Environment(StreamingViewModel.self) var streamingViewModel
    
    /// 进度调整完成时调用的闭包.
    private var onSeekCompleted: (() -> Void)?
    
    init(seekPosition: Binding<Double>, onSeekCompleted: (() -> Void)? = nil) {
        self._seekPosition = seekPosition
        self.onSeekCompleted = onSeekCompleted
    }
    
    var body: some View {
        HStack {
            Text(formatTime(streamingViewModel.currentTime))
            
            Slider(value: $seekPosition, in: 0...1, onEditingChanged: { isEditing in
                if !isEditing {
                    /// 使用`onChange`计算出的时间, 修改播放进度.
                    streamingViewModel.player.seek(
                        to: CMTime(
                            seconds: streamingViewModel.currentTime,
                            preferredTimescale: 1000
                        )
                    )
                    
                    onSeekCompleted?()
                }
            })
            .onChange(of: seekPosition, {
                /// 获取当前播放的视频.
                guard let currentVideo = streamingViewModel.player.currentItem
                else {
                    return
                }
                
                /// 根据当前位置和视频总时长计算修改后的时间.
                let totalDuration = currentVideo.duration.seconds
                
                streamingViewModel.currentTime = seekPosition * totalDuration
                streamingViewModel.remainingTime = totalDuration - streamingViewModel.currentTime
            })
                
            Text(formatTime(streamingViewModel.remainingTime))
        }
        .bold()
        .font(.footnote)
        .foregroundStyle(Color(hex: "#F9F9F9"))
        .tint(Color(hex: "#F9F9F9"))
        .onAppear(perform: {
            observePlayerProgress()
        })
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
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// 观察播放器的播放进度.
    private func observePlayerProgress() {
        streamingViewModel.player.addPeriodicTimeObserver(
            /// 每隔0.5秒获取一次新的播放进度.
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000),
            queue: nil,
            using: { _ in
                /// 获取当前播放的视频.
                guard let currentVideo = streamingViewModel.player.currentItem
                else {
                    return
                }
                
                /// 计算新的进度条位置.
                if currentVideo.duration.isNumeric {
                    let currentTime = streamingViewModel.player.currentTime().seconds
                    seekPosition = currentTime / currentVideo.duration.seconds
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var seekPosition: Double = 0.0
    
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    
    ProgressBar(seekPosition: $seekPosition)
        .environment(streamingViewModel)
}
