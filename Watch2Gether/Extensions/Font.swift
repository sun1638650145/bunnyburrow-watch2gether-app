//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Font.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2025/1/7.
//

import SwiftUI
import UIKit

extension Font {
    /// 转换成`UIFont`
    ///
    /// - Returns: 转换后的`UIFont`.
    func toUIFont() -> UIFont {
        /// 用于映射`Font`到`UIFont.TextStyle`.
        let fontStyleMap: [Font: UIFont.TextStyle] = [
            .largeTitle: .largeTitle,
            .title: .title1,
            .title2: .title2,
            .title3: .title3,
            .headline: .headline,
            .subheadline: .subheadline,
            .body: .body,
            .callout: .callout,
            .footnote: .footnote,
            .caption: .caption1,
            .caption2: .caption2
        ]

        let textStyle = fontStyleMap[self] ?? .body
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)

        return UIFont(descriptor: descriptor, size: descriptor.pointSize)
    }
}
