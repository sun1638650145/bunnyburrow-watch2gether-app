//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ImagePicker.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import AppKit
import Foundation
import SwiftUI
import UniformTypeIdentifiers

/// `ImagePicker`是使用`NSOpenPanel`实现的图片选择的工具;
/// 它允许用户选择一张图片, 并将图片转换成Base-64编码的字符串.
struct ImagePicker {
    @Binding var selectedImage: String?

    /// 展示`NSOpenPanel`允许用户上传图片.
    func present() {
        let openPanel = NSOpenPanel()

        /// 目前允许用户选择GIF, HEIC(HEIF), JPEG(JPG), PNG和SVG格式的图片文件.
        openPanel.allowedContentTypes = [UTType.gif, UTType.heic, UTType.heif, UTType.jpeg, UTType.png, UTType.svg]

        /// 作为模态窗口展示.
        let response = openPanel.runModal()

        /// 使用主线程执行, 提高稳定性.
        DispatchQueue.main.async {
            if response == .OK {
                if let url = openPanel.url,
                   let image = NSImage(contentsOf: url) {
                    /// 调整到500x500像素以内的大小并转换成Base-64编码的字符串.
                    self.selectedImage = image
                        .resize(within: NSSize(width: 500, height: 500))
                        .toBase64()
                }
            }
        }
    }
}
