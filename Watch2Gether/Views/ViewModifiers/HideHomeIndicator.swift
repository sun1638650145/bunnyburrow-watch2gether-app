//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  HideHomeIndicator.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/10/18.
//

import SwiftUI

/// `HideHomeIndicator`是隐藏主页指示器(Home indicator)的视图修饰符, 仅在低于iOS 26的版本启用.
struct HideHomeIndicator: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
        } else {
            content
                .persistentSystemOverlays(.hidden)
        }
    }
}
