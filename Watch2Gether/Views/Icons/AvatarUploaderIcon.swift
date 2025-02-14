//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AvatarUploaderIcon.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/9/27.
//

import SwiftUI

/// `AvatarUploaderIcon`是头像上传图标.
struct AvatarUploaderIcon: View {
    /// 头像上传图标的大小.
    let size: Double

    /// 十字图案的宽度.
    let crossWidth: Double

    /// 十字图案的高度.
    let crossHeight: Double

    var body: some View {
        Circle()
            .subtracting(CrossShape(width: crossWidth, height: crossHeight))
            .foregroundStyle(Color.viewBackground)
            .frame(width: size, height: size)
    }
}

#Preview {
    AvatarUploaderIcon(size: 100, crossWidth: 35, crossHeight: 5)
}
