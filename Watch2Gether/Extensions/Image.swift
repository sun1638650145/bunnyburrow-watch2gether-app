//
//  Image.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/6.
//

import SwiftUI

extension Image {
    /// 从图片的Base-64编码字符串初始化`Image`(此初始化方法同时支持`iOS`和`macOS`平台).
    ///
    /// - Parameters:
    ///   - base64: 图片的Base-64编码字符串.
    init(base64: String) {
        /// 在iOS上使用`toUIImage`将字符串转换成`UIImage`.
        #if os(iOS)
        self.init(uiImage: base64.toUIImage()!)
        
        /// 在macOS上使用`toNSImage`将字符串转换成`NSImage`.
        #elseif os(macOS)
        self.init(nsImage: base64.toNSImage()!)
        #endif
    }
}
