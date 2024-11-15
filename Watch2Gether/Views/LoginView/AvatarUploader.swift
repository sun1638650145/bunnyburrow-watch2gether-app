//
//  AvatarUploader.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import SwiftUI

struct AvatarUploader: View {
    @Binding var avatar: String?
    
    /// 是否呈现`ImagePickerViewController`状态.
    @State private var isPresented = false
    
    init(_ avatar: Binding<String?>) {
        self._avatar = avatar
    }
    
    var body: some View {
        Button(action: {
            isPresented = true
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
        .sheet(isPresented: $isPresented, content: {
            ImagePickerViewController(selectedImage: $avatar)
        })
    }
}

#Preview {
    @Previewable @State var avatar: String?
    
    AvatarUploader($avatar)
}
