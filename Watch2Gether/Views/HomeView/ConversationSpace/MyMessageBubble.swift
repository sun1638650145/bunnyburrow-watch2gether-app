//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MyMessageBubble.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/1/12.
//

import SwiftUI

/// `MyMessageBubble`是用于显示用户自己的聊天消息的视图.
struct MyMessageBubble: View {
    /// 聊天消息的内容.
    let content: String

    /// 用户头像的Base-64.
    let avatar: String?

    var body: some View {
        HStack(alignment: .top, content: {
            /// 用于将内容向右对齐.
            Spacer()

            Text(content)
                .frame(minWidth: 16)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .background(Color.myMessageBubbleBackground)
                .clipShape(MyMessageBubbleShape())
                .foregroundStyle(Color.foreground)
                /// 调整自动换行的位置, 让出其他用户头像显示的宽度使得视觉上更加美观.
                .padding(.leading, 40)

            Image(base64: avatar ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        })
        .padding(5)
    }
}

#Preview {
    Group {
        MyMessageBubble(content: "一条消息", avatar: nil)

        MyMessageBubble(content: "这条长消息用于测试样式是否按预期自动换行.", avatar: nil)
    }
}
