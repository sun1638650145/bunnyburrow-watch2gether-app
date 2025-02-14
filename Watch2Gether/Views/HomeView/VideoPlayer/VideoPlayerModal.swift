//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayerModal.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/4.
//

import SwiftUI

/// `VideoPlayerModal`是视频播放器模态视图, 用于显示状态同步的通知信息.
struct VideoPlayerModal: View {
    /// 模态视图开关变量.
    private let isOpen: Bool

    /// 显示的通知信息变量.
    private let notificationMessage: String

    init(_ notificationMessage: String, isOpen: Bool) {
        self.notificationMessage = notificationMessage
        self.isOpen = isOpen
    }

    var body: some View {
        if isOpen {
            Text(notificationMessage)
                .padding(12)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .font(.callout)
                .foregroundStyle(Color.foreground)
        }
    }
}

#Preview {
    VideoPlayerModal("通知信息", isOpen: true)
}
