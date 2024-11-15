//
//  AvatarUploader.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import SwiftUI

struct AvatarUploader: View {
    @Binding var avatar: String?
    @Binding var isImagePickerActive: Bool
    
    init(_ avatar: Binding<String?>, _ isImagePickerActive: Binding<Bool>) {
        self._avatar = avatar
        self._isImagePickerActive = isImagePickerActive
    }
    
    var body: some View {
        Button(action: {
            isImagePickerActive = true
            ImagePicker(selectedImage: $avatar).present()
            isImagePickerActive = false
        }, label: {
            if let avatar = avatar {
                Image(base64: avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .overlay(content: {
                        Circle().stroke(Color(hex: "#E5E7EB"), lineWidth: 2)
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
    
    AvatarUploader($avatar, .constant(false))
}
