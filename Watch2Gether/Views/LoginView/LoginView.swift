//
//  LoginView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var user: User?
    
    /// 用户的头像.
    @State private var avatar: PlatformImage?
    
    /// 用户的昵称.
    @State private var name: String?
    
    var body: some View {
        VStack {
            Text("一起看电影")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color(hex: "#F9F9F9"))
                .padding(10)
            
            AvatarUploader($avatar)
            
            Group {
                StyledPlaceholderTextField(
                    "请输入昵称",
                    text: $name,
                    placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255)
                )
            }
            .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(10)
            
            LoginButton($isLoggedIn)
        }
    }
}

#Preview {
    @State var isLoggedIn = false
    @State var user: User?
    
    return LoginView(isLoggedIn: $isLoggedIn, user: $user)
}
