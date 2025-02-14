//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  String.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import AppKit
import Foundation

extension String {
    /// 计算字符串在指定`NSFont`字体下的渲染高度.
    ///
    /// - Parameters:
    ///   - nsFont: 渲染时使用的`NSFont`字体.
    /// - Returns: 字符串的渲染高度.
    func renderedHeight(usingFont nsFont: NSFont) -> Double {
        /// 设置字体属性字典.
        let attrs = [NSAttributedString.Key.font: nsFont]

        let size = (self as NSString).size(withAttributes: attrs)

        return size.height
    }

    /// 计算字符串在指定`NSFont`字体下的渲染宽度.
    ///
    /// - Parameters:
    ///   - font: 渲染时使用的`NSFont`字体.
    /// - Returns: 字符串的渲染宽度.
    func renderedWidth(usingFont nsFont: NSFont) -> Double {
        /// 设置字体属性字典.
        let attrs = [NSAttributedString.Key.font: nsFont]

        let size = (self as NSString).size(withAttributes: attrs)

        return size.width
    }

    /// 将Base-64编码的字符串转换为`NSImage`.
    ///
    /// - Returns: `NSImage`图片实例.
    func toNSImage() -> NSImage {
        /// 定义正则表达式并去除`DataURL`.
        guard let regex = try? NSRegularExpression(
            /// 目前支持GIF, HEIC(HEIF), JPEG(JPG), PNG和SVG格式的图片.
            pattern: "^data:image/(gif|heic|heif|jpeg|png|svg);base64,",
            options: .caseInsensitive
        ) else {
            /// 正则表达式初始化失败则返回纯白色图片.
            return NSImage.whiteImage()
        }

        let base64 = regex.stringByReplacingMatches(
            in: self,
            range: NSRange(location: 0, length: self.count),
            withTemplate: ""
        )

        /// 先将字符串编码成`Data`, 然后初始化为`NSImage`.
        if let data = Data(base64Encoded: base64),
           let image = NSImage(data: data) {
            return image
        } else {
            /// 无法解码则返回纯白色图片.
            return NSImage.whiteImage()
        }
    }
}
