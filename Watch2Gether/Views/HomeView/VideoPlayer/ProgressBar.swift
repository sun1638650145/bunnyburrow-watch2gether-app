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
    @Environment(Streaming.self) var streaming
    
    /// 进度调整完成时调用的闭包.
    private var onSeekCompleted: (() -> Void)?
    
    init(seekPosition: Binding<Double>, onSeekCompleted: (() -> Void)? = nil) {
        self._seekPosition = seekPosition
        self.onSeekCompleted = onSeekCompleted
    }
    
    var body: some View {
        HStack {
            Text(formatTime(streaming.currentTime))
            
            Slider(value: $seekPosition, in: 0...1, onEditingChanged: { isEditing in
                if !isEditing {
                    /// 使用`onChange`计算出的时间, 修改播放进度.
                    streaming.player.seek(
                        to: CMTime(seconds: streaming.currentTime, preferredTimescale: 1000)
                    )
                    
                    onSeekCompleted?()
                }
            })
            .onChange(of: seekPosition, {
                /// 获取当前播放的视频.
                guard let currentVideo = streaming.player.currentItem
                else {
                    return
                }
                
                /// 根据当前位置和视频总时长计算修改后的时间.
                let totalDuration = currentVideo.duration.seconds
                
                streaming.currentTime = seekPosition * totalDuration
                streaming.remainingTime = totalDuration - streaming.currentTime
            })
                
            Text(formatTime(streaming.remainingTime))
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
        streaming.player.addPeriodicTimeObserver(
            /// 每隔0.5秒获取一次新的播放进度.
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000),
            queue: nil,
            using: { _ in
                /// 获取当前播放的视频.
                guard let currentVideo = streaming.player.currentItem
                else {
                    return
                }
                
                /// 计算新的进度条位置.
                if currentVideo.duration.isNumeric {
                    let currentTime = streaming.player.currentTime().seconds
                    seekPosition = currentTime / currentVideo.duration.seconds
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var seekPosition: Double = 0.0
    
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    ProgressBar(seekPosition: $seekPosition)
        .environment(streaming)
}
