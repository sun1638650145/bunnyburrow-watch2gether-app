//
//  LoginView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var user: User?
    @Binding var streaming: Streaming?
    
    /// 用户的头像.
    @State private var avatar: PlatformImage?
    
    /// 用户的昵称.
    @State private var name: String?
    
    /// 视频源url.
    @State private var url: String?
    
    /// 昵称为空变量.
    @State private var isNameEmpty = false
    
    /// 流媒体视频源不合法变量.
    @State private var isStreamingInvalid = false
    
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
            
            StyledPlaceholderTextField(
                "请输入流媒体视频源",
                text: $url,
                placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
                errorMessage: isStreamingInvalid ? "流媒体视频源为空或者不合法, 请重新输入视频源并重试." : nil
            )
            
            Button(action: handleLogin, label: {
                Text("加入")
            })
            .buttonStyle(LoginButtonStyle())
        }
    }
    
    private func handleLogin() {
        /// 检查昵称是否为空.
        isNameEmpty = name?.isEmpty ?? true
        
        /// 检查流媒体视频源是否合法.
        if let url = url, let url = URL(string: url), url.scheme != nil, url.host() != nil {
            isStreamingInvalid = false
        } else {
            isStreamingInvalid = true
        }
        
        if !isNameEmpty && !isStreamingInvalid {
            user = User(avatar, name!)
            streaming = Streaming(url: URL(string: url!)!)

            if let user = user, let streaming = streaming {
                print(
                    """
                    头像: \(String(describing: user.avatar))
                    客户端ID: \(user.clientID)
                    昵称: \(user.name)
                    流媒体视频源: \(streaming.url)
                    """
                )
            }
        }
        
        /// 设置登录状态.
        isLoggedIn = !isNameEmpty && !isStreamingInvalid
    }
}

#Preview {
    @State var isLoggedIn = false
    @State var user: User?
    @State var streaming: Streaming?
    
    return LoginView(isLoggedIn: $isLoggedIn, user: $user, streaming: $streaming)
}
