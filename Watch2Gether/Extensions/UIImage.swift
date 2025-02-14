//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  UIImage.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/5.
//

import CoreGraphics
import UIKit

extension UIImage {
    /// 调整`UIImage`的大小到`maxSize`范围内.
    ///
    /// - Parameters:
    ///   - maxSize: 包含宽度和高度的`CGSize`, 表示调整大小后的最大尺寸.
    /// - Returns: 调整后的`UIImage`图片实例.
    func resize(within maxSize: CGSize) -> UIImage {
        let scale = min(maxSize.width / self.size.width, maxSize.height / self.size.height)

        if scale < 1 {
            /// 计算调整大小后的新尺寸.
            let newSize = CGSize(width: scale * self.size.width, height: scale * self.size.height)

            let format = UIGraphicsImageRendererFormat()

            /// 设置图片的缩放比例.
            format.scale = self.scale

            let renderer = UIGraphicsImageRenderer(size: newSize, format: format)

            return renderer.image(actions: { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
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
        /// 使用`pngData()`将图片转换成数据.
        guard let data = self.pngData()
        else {
            return nil
        }

        return "data:image/png;base64,\(data.base64EncodedString())"
    }

    /// 创建纯白色的`UIImage`实例.
    ///
    /// - Returns: 返回大小为1x1像素的纯白色的`UIImage`.
    static func whiteImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))

        return renderer.image(actions: { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        })
    }
}
