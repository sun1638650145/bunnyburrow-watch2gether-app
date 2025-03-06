//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VolumeSlider.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/6.
//

import SwiftUI

/// `VolumeSlider`是音量滑块视图.
struct VolumeSlider: View {
    /// 当前的音量.
    let volume: Float

    /// 计算当前音量对应符号的名称.
    private var volumeSymbol: String {
        switch volume {
        case 0:
            return "volume.slash.fill"
        case 0...0.3:
            return "volume.1.fill"
        case 0.3..<0.7:
            return "volume.2.fill"
        default:
            return "volume.3.fill"
        }
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: volumeSymbol)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color.foreground)
                    .frame(width: 20, height: 20)

                ZStack(alignment: .leading, content: {
                    /// 滑轨的背景部分.
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(Color.foreground.opacity(0.2))
                        .frame(width: 100, height: 4)

                    /// 滑轨的前景部分(已滑过的部分).
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(Color.volumeSliderForeground.gradient)
                        .frame(width: CGFloat(volume * 100), height: 4)
                })
            }
            .padding(10)

            Spacer()
        }
    }
}

#Preview {
    VolumeSlider(volume: 0.5)
}
