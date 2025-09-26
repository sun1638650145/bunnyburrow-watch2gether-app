//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  GlassEffectCompat.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/9/26.
//

import SwiftUI

/// `GlassEffectCompat`是为`View`应用液态玻璃(Liquid Glass)效果的视图修饰符, 在iOS 26以及上版本启用.
struct GlassEffectCompat: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect()
        } else {
            content
                .background(.regularMaterial)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    Text("Hello, World!")
        .padding(12)
        .modifier(GlassEffectCompat())
}
