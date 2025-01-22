//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Color.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/8/4.
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
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)

        /// 提取红, 绿和蓝色分量.
        let red = Int(hex.prefix(2), radix: 16) ?? 0
        let green = Int(hex.dropFirst(2).prefix(2), radix: 16) ?? 0
        let blue = Int(hex.dropFirst(4), radix: 16) ?? 0

        self.init(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }

    /// 用于警告和错误提示的颜色.
    public static let alertError = Color(hex: "#FF554C")

    /// 用于头像边框的颜色.
    public static let avatarBorder = Color(hex: "E5E7EB")

    /// 用于背景内容的颜色.
    public static let background = Color(hex: "#1A1D29")

    /// 用于前景文本的颜色.
    public static let foreground = Color(hex: "#F9F9F9")

    /// 用于加入按钮背景的颜色.
    public static let loginButtonBackground = Color(hex: "#0682F0")

    /// 用于用户自己的聊天消息气泡背景的颜色.
    public static let myMessageBubbleBackground = Color(hex: "#0052D9")

    /// 用于其他用户的聊天消息气泡背景的颜色.
    public static let otherMessageBubbleBackground = Color(hex: "#2C2C2C")

    /// 用于发送按钮结束渐变背景的颜色.
    public static let sendButtonGradientEnd = Color(hex: "#062794")

    /// 用于发送按钮起始渐变背景的颜色.
    public static let sendButtonGradientStart = Color(hex: "#095AE6")

    /// 用于文本输入框的高亮提示的颜色.
    public static let textFieldHighlight = Color(red: 249.0 / 255, green: 249.0 / 255, blue: 249.0 / 255, opacity: 0.2)

    /// 用于文本输入框占位文本的颜色.
    public static let textFieldPlaceholder = Color(red: 169.0 / 255, green: 169.0 / 255, blue: 169.0 / 255)

    /// 用于视图背景的颜色.
    public static let viewBackground = Color(red: 249.0 / 255, green: 249.0 / 255, blue: 249.0 / 255, opacity: 0.1)
}
