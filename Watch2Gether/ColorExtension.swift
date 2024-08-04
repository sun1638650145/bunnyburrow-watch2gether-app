//
//  ColorExtension.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/4.
//

import Foundation
import SwiftUI

extension Color {
    /// 从十六进制字符串初始化`Color`(例如: `#1A1D29`).
    ///
    /// - Parameters:
    ///   - hex: 以十六进制表示颜色的字符串.
    init(hex: String) {
        /// 删除字符`#`.
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        /// 提取红, 绿和蓝色分量.
        let red = Int(hex.prefix(2), radix: 16) ?? 0
        let green = Int(hex.dropFirst(2).prefix(2), radix: 16) ?? 0
        let blue = Int(hex.dropFirst(4), radix: 16) ?? 0
        
        self.init(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}
