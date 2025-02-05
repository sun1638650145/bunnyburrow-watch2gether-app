//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Float.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2025/2/5.
//

import Foundation

extension Float {
    /// 格式化播放速率为字符串.
    ///
    /// - Returns: 格式化后的播放速率字符串.
    func formattedPlaybackRate() -> String {
        let formatter = NumberFormatter()

        /// 指定小数点后的最少和最多显示的位数.
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        return formatter.string(for: self) ?? String(self)
    }
}
