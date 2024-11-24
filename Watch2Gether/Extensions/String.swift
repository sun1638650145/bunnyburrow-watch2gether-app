//
//  String.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/5.
//

import Foundation
import UIKit

extension String {
    /// 将Base-64编码的字符串转换为`UIImage`.
    ///
    /// - Returns: `UIImage`图片实例.
    func toUIImage() -> UIImage {
        /// 定义正则表达式并去除`DataURL`.
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
        
        /// 先将字符串编码成`Data`, 然后初始化为`UIImage`.
        if let data = Data(base64Encoded: base64),
           let image = UIImage(data: data) {
            return image
        } else {
            /// 无法解码则返回纯白色图片.
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
            
            return renderer.image(actions: { context in
                UIColor.white.setFill()
                context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            })
        }
    }
}
