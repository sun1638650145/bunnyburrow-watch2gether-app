//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Double.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/7/19.
//

extension Double {
    /// 将时间格式化为`hh:mm:ss`或者`mm:ss`格式的字符串.
    ///
    /// - Returns: 格式化后的时间字符串.
    func formattedTime() -> String {
        let totalSeconds = Int(self)

        let hours = totalSeconds / 3600
        let minutes = totalSeconds % 3600 / 60
        let seconds = totalSeconds % 60

        return hours > 0
        ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        : String(format: "%02d:%02d", minutes, seconds)
    }
}
