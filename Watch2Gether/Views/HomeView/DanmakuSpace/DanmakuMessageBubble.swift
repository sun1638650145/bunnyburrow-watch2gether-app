//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DanmakuMessageBubble.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/17.
//

import SwiftUI

/// `DanmakuMessageBubble`是用于以弹幕形式显示聊天消息的视图.
struct DanmakuMessageBubble: View {
    /// 聊天消息的内容.
    let content: String

    /// 用户头像的Base-64.
    let avatar: String?

    var body: some View {
        Text(content)
            .frame(minWidth: 16)
            .padding(12)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .font(.callout)
            .foregroundStyle(Color.foreground)
            .lineLimit(1)
            .overlay(alignment: .topTrailing, content: {
                Image(base64: avatar ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .offset(x: 15, y: -15)
            })
            /// 用于调整多个视图之间的间隔避免重叠遮挡.
            .padding(10)
    }
}

#Preview {
    DanmakuMessageBubble(content: "一条消息", avatar: nil)
}
