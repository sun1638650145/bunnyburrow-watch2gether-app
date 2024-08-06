//
//  AvatarUploader.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import SwiftUI

struct AvatarUploader: View {
    /// 按钮悬停状态.
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            // ...
        }, label: {
            Image("AvatarUploader")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .padding(5)
        })
        .buttonStyle(PlainButtonStyle())
        .onHover(perform: { hovering in
            isHovered = hovering
            
            /// 在悬停时使用手形光标.
            if isHovered {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
    }
}

#Preview {
    AvatarUploader()
}
