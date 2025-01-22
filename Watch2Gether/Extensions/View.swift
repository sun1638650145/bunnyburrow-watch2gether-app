//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  View.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/11/8.
//

import SwiftUI

extension View {
    /// 为`View`添加版权信息的样式.
    ///
    /// - Returns: 应用`Copyright`样式后的视图.
    func copyright() -> some View {
        self.modifier(Copyright())
    }
}
