//
//  MyMessage.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/30.
//

import SwiftUI

struct MyMessage: View {
    /// 聊天消息的内容.
    var content: String
    
    /// 用户头像的Base64.
    var avatar: String?
    
    var body: some View {
        HStack {
            // TODO: 暂未设置消息气泡的箭头样式和最大宽度(Steve).
            Text(content)
                .frame(minWidth: 16)
                .padding(8)
                .background(Color(hex: "#29B560"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(Color.primary)
            
            Image(base64: avatar ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .overlay(content: {
                    Circle().stroke(Color(hex: "#E5E7EB"), lineWidth: 2)
                })
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        /// 修改列表行的背景颜色.
        .listRowBackground(Color(hex: "#1A1D29"))
        /// 隐藏列表行的分隔符.
        .listRowSeparator(.hidden)
    }
}

#Preview {
    MyMessage(content: "一条消息", avatar: nil)
}
