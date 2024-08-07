//
//  AvatarUploader.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import SwiftUI

struct AvatarUploader: View {
    @Binding var avatar: PlatformImage?
    
    /// 按钮悬停状态.
    @State private var isHovered = false
    
    /// 是否呈现`ImagePickerViewController`状态.
    @State private var isPresented = false
    
    init(_ avatar: Binding<PlatformImage?>) {
        self._avatar = avatar
    }
    
    var body: some View {
        Button(action: {
            isPresented = true
        }, label: {
            if let avatar = avatar {
                Image(platformImage: avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Color(hex: "#E5E7EB"), lineWidth: 2))
                    .padding(5)
            } else {
                Image("AvatarUploader")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .padding(5)
            }
        })
        .buttonStyle(PlainButtonStyle())
        #if os(macOS)
        .onHover(perform: { hovering in
            isHovered = hovering
            
            /// 在悬停时使用手形光标.
            if isHovered {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
        #endif
        .sheet(isPresented: $isPresented, content: {
            ImagePickerViewController(selectedImage: $avatar)
                .frame(width: 0, height: 0)
        })
    }
}

#Preview {
    @State var avatar: PlatformImage?
    
    return AvatarUploader($avatar)
}
