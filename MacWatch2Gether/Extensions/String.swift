//
//  String.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import AppKit
import Foundation

extension String {
    /// 将Base-64编码的字符串为`NSImage?`.
    ///
    /// - Returns: `NSImage?`图片实例.
    func toNSImage() -> NSImage? {
        /// 定义正则表达式并去除DataURL.
        let regex = try! NSRegularExpression(
            /// 目前支持GIF, HEIC(HEIF), JEPG(JPG), PNG和SVG格式的图片.
            pattern: "^data:image/(gif|heic|heif|jpeg|png|svg);base64,",
            options: .caseInsensitive
        )
        let base64 = regex.stringByReplacingMatches(
            in: self,
            range: NSRange(location: 0, length: self.count),
            withTemplate: ""
        )
        
        /// 先将字符串编码成`Data`, 然后初始化为`NSImage`.
        guard let data = Data(base64Encoded: base64),
              let image = NSImage(data: data)
        else {
            return nil
        }
        
        return image
    }
}
