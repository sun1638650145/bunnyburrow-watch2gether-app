//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AvatarUploader.swift
//  MacWatch2Gether
//
//  Create by Steve R. Sun on 2024/11/7.
//

import SwiftUI

/// `AvatarUploader`是用于头像上传的视图, 允许用户上传并展示头像.
struct AvatarUploader: View {
    @Binding var avatar: String?
    @Environment(AppSettings.self) var appSettings

    init(_ avatar: Binding<String?>) {
        self._avatar = avatar
    }

    var body: some View {
        Button(action: {
            appSettings.isImagePickerActive = true
            ImagePicker(selectedImage: $avatar).present()
            appSettings.isImagePickerActive = false
        }, label: {
            if let avatar = avatar {
                Image(base64: avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    /// 在`frame`之后应用, 解决动画过程中图片溢出边框的问题.
                    .clipShape(Circle())
                    .overlay(content: {
                        Circle().stroke(Color.avatarBorder, lineWidth: 2)
                    })
                    .padding(5)
            } else {
                AvatarUploaderIcon(size: 100, crossWidth: 35, crossHeight: 5)
                    .padding(5)
            }
        })
        .animation(.easeIn(duration: 1.2), value: avatar)
        .buttonStyle(PlainButtonStyle())
        .onHover(perform: { hovering in
            /// 在悬停时使用手形光标.
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
    }
}

#Preview {
    @Previewable @State var avatar: String?

    let appSettings = AppSettings()

    AvatarUploader($avatar)
        .environment(appSettings)
}
