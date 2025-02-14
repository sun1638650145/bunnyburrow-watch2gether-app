//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Font.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/1/7.
//

import AppKit
import SwiftUI

extension Font {
    /// 转换成`NSFont`.
    ///
    /// - Returns: 转换后的`NSFont`.
    func toNSFont() -> NSFont {
        /// 用于映射`Font`到`NSFont.TextStyle`.
        let fontStyleMap: [Font: NSFont.TextStyle] = [
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
        let descriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: textStyle)

        return NSFont(descriptor: descriptor, size: descriptor.pointSize)!
    }
}
