//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPicker.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/18.
//

import SwiftUI

/// `VideoPicker`是视频选择的视图, 允许用户选择一个本地视频文件.
struct VideoPicker: View {
    var body: some View {
        Button(action: {
            // ...
        }, label: {
            Image(systemName: "document.badge.plus.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.foreground)
        })
    }
}

#Preview {
    VideoPicker()
}
