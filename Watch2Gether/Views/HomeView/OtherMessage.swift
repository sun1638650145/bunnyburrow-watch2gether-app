//
//  OtherMessage.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/30.
//

import SwiftUI

struct OtherMessage: View {
    /// 聊天消息的内容.
    var content: String
    
    /// 用户头像的Base64.
    var avatar: String?
    
    /// 用户的昵称.
    var name: String
    
    var body: some View {
        HStack {
            Image(base64: avatar ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .overlay(content: {
                    Circle().stroke(Color(hex: "#E5E7EB"), lineWidth: 2)
                })
            
            VStack(alignment: .leading, content: {
                Text(name)
                    .font(.caption)
                
                // TODO: 暂未设置消息气泡的箭头样式和最大宽度(Steve).
                Text(content)
                    .frame(minWidth: 16)
                    .padding(8)
                    .background(Color(hex: "#2C2C2C"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            })
            .foregroundStyle(Color(hex: "#F9F9F9"))
        }
        /// 修改列表行的背景颜色.
        .listRowBackground(Color(hex: "#1A1D29"))
        /// 隐藏列表行的分隔符.
        .listRowSeparator(.hidden)
    }
}

#Preview {
    OtherMessage(content: "这是一条消息", avatar: nil, name: "A")
}
