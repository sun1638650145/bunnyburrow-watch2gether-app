//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPlayerModal.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/4.
//

import Foundation
import SwiftUI

/// `VideoPlayerModal`是视频播放器模态视图, 用于显示状态同步的通知信息.
struct VideoPlayerModal: View {
    /// 模态视图开关变量.
    private let isOpen: Bool

    /// 显示的通知信息变量.
    private let notificationMessage: LocalizedStringResource

    init(_ notificationMessage: LocalizedStringResource, isOpen: Bool) {
        self.notificationMessage = notificationMessage
        self.isOpen = isOpen
    }

    var body: some View {
        if isOpen {
            Text(notificationMessage)
                .padding(12)
                .font(.callout)
                .foregroundStyle(Color.foreground)
                .glassEffectCompat()
        }
    }
}

#Preview {
    VideoPlayerModal("通知信息", isOpen: true)
}
