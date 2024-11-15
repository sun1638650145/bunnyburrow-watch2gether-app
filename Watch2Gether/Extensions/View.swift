//
//  View.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/8.
//

import SwiftUI

extension View {
    /// 为`View`添加版权的样式.
    ///
    /// - Returns: 应用`Copyright` 样式后的视图.
    func copyright() -> some View {
        self.modifier(Copyright())
    }
}
