//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  OtherMessageBubble.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/1/12.
//

import SwiftUI

/// `OtherMessageBubble`是用于显示其他用户的聊天消息的视图.
struct OtherMessageBubble: View {
    /// 聊天消息的内容.
    let content: String

    /// 用户头像的Base-64.
    let avatar: String?

    /// 用户的昵称.
    let name: String

    var body: some View {
        HStack(alignment: .top, content: {
            Image(base64: avatar ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 2, content: {
                Text(name)
                    .font(.caption)
                    .padding(.leading, 5)

                Text(content)
                    .frame(minWidth: 16)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .background(Color.otherMessageBubbleBackground)
                    .clipShape(OtherMessageBubbleShape())
                    /// 调整自动换行的位置, 让出用户自己头像显示的宽度使得视觉上更加美观.
                    .padding(.trailing, 40)
            })
            .foregroundStyle(Color.foreground)

            /// 用于将内容向左对齐.
            Spacer()
        })
        .padding(5)
    }
}

#Preview {
    OtherMessageBubble(content: "一条消息", avatar: nil, name: "A")
}
