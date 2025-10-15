//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  BrightnessSlider.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/10/9.
//

import SwiftUI

/// `BrightnessSlider`是亮度滑块视图.
struct BrightnessSlider: View {
    /// 当前的亮度.
    let brightness: CGFloat

    var body: some View {
        VStack {
            HStack {
                Image(systemName: brightness < 0.5 ? "sun.min.fill" : "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color.yellow)
                    .frame(width: 20, height: 20)

                ZStack(alignment: .leading, content: {
                    /// 滑轨的背景部分.
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(Color.foreground.opacity(0.2))
                        .frame(width: 100, height: 4)

                    /// 滑轨的前景部分(已滑过的部分).
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(Color.brightnessSliderForeground)
                        .frame(width: CGFloat(brightness * 100), height: 4)
                })
            }
            .padding(10)
            .glassEffectCompat()

            Spacer()
        }
    }
}

#Preview {
    BrightnessSlider(brightness: 0.5)
}
