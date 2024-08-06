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
}
