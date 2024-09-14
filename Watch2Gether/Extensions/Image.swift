//
//  Image.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/6.
//

import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

extension Image {
    /// 从特定平台的图片初始化`Image`.
    ///
    /// - Parameters:
    ///   - platformImage: 特定平台的图片.
    init(platformImage: PlatformImage) {
        /// 在iOS上, 实际上从`UIImage`图片初始化.
        #if os(iOS)
        self.init(uiImage: platformImage)
        
        /// 在macOS上, 实际上从`NSImage`图片初始化.
        #elseif os(macOS)
        self.init(nsImage: platformImage)
        #endif
    }
    
    /// 将任意平台的图片转换成Base-64编码的字符串.
    ///
    /// - Parameter platformImage: 特定平台的图片.
    /// - Returns: 图片的Base-64编码字符串.
    static func convertToBase64(platformImage: PlatformImage?) -> String? {
        /// 在iOS上, 使用`pngData()`将图片转换成数据.
        #if os(iOS)
        guard let image = platformImage,
              let data = image.pngData()
        else {
            return nil
        }
        
        /// 在macOS上, 先将图片转换成tiff格式, 再转换为bitmap格式, 最后转换成数据.
        #elseif os(macOS)
        guard let image = platformImage,
              let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let data = bitmap.representation(using: .png, properties: [:])
        else {
            return nil
        }
        #endif
        
        return "data:image/png;base64,\(data.base64EncodedString())"
    }
}
