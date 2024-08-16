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
    
    /// 昵称为空变量.
    @State private var isNameEmpty = false
    
    var body: some View {
        VStack {
            Text("一起看电影")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color(hex: "#F9F9F9"))
                .padding(10)
            
            AvatarUploader($avatar)
            
            StyledPlaceholderTextField(
                "请输入昵称",
                text: $name,
                placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
                errorMessage: isNameEmpty ? "昵称不能为空, 请输入昵称并重试." : nil
            )
            
            Button(action: {
                if let name = name, !name.isEmpty {
                    user = User(avatar, name)
                    
                    if let user = user {
                        print(
                            """
                            头像: \(String(describing: user.avatar))
                            客户端ID: \(user.clientID)
                            昵称: \(user.name)
                            """
                        )
                    }
                    
                    /// 昵称不为空时, 设置登录状态.
                    isLoggedIn = true
                } else {
                    isNameEmpty = true
                }
            }, label: {
                Text("加入")
            })
            .buttonStyle(LoginButtonStyle())
        }
    }
}

#Preview {
    @State var isLoggedIn = false
    @State var user: User?
    
    return LoginView(isLoggedIn: $isLoggedIn, user: $user)
}
