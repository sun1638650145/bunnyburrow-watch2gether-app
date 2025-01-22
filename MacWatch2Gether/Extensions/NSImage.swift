//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  NSImage.swift
//  MacWatch2Gether
//
//  Create by Steve R. Sun on 2024/11/7.
//

import AppKit
import Foundation

extension NSImage {
    /// 调整`NSImage`的大小到`maxSize`范围内.
    ///
    /// - Parameters:
    ///   - maxSize: 包含宽度和高度的`NSSize`, 表示调整大小后的最大尺寸.
    /// - Returns: 调整后的`UIImage`图片实例.
    func resize(within maxSize: NSSize) -> NSImage {
        let scale = min(maxSize.width / self.size.width, maxSize.height / self.size.height)

        if scale < 1 {
            /// 计算调整大小后的新尺寸.
            let newSize = NSSize(width: scale * self.size.width, height: scale * self.size.height)

            return NSImage(size: newSize, flipped: false, drawingHandler: { _ in
                self.draw(in: NSRect(origin: .zero, size: newSize))

                return true
            })
        } else {
            /// 图片已经小于指定大小不进行处理.
            return self
        }
    }

    /// 转换成Base-64编码的字符串.
    ///
    /// - Returns: 图片的Base-64编码字符串.
    func toBase64() -> String? {
        /// 先将图片转换成tiff格式, 再转换为bitmap格式, 最后转换成数据.
        guard let tiff = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let data = bitmap.representation(using: .png, properties: [:])
        else {
            return nil
        }

        return "data:image/png;base64,\(data.base64EncodedString())"
    }

    /// 创建纯白色的`NSImage`实例.
    ///
    /// - Returns: 返回大小为1x1像素的纯白色的`NSImage`.
    static func whiteImage() -> NSImage {
        return NSImage(size: NSSize(width: 1, height: 1), flipped: false, drawingHandler: { rect in
            NSColor.white.setFill()
            rect.fill()

            return true
        })
    }
}
