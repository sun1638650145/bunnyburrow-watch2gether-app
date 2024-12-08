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
    @Environment(User.self) var user
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(Streaming.self) var streaming
    @Environment(WebSocketClient.self) var websocketClient
    
    /// 用户的头像的Base-64.
    @AppStorage("LoginView.avatar") private var avatar: String?
    
    /// 用户的昵称.
    @AppStorage("LoginView.name") private var name: String?
    
    /// 视频源URL.
    @AppStorage("LoginView.url") private var url: String?
    
    /// WebSocket服务地址.
    @AppStorage("LoginView.websocketUrl") private var websocketUrl: String?
        
    /// 获取焦点位置.
    @FocusState private var focusedField: FocusedField?
    
    /// 昵称为空变量.
    @State private var isNameEmpty = false
    
    /// 流媒体视频源不合法状态变量.
    @State private var isStreamingInvalid = false
    
    /// WebSocket服务地址不合法状态变量.
    @State private var isWebSocketInvalid = false
    
    /// 用于标记获取焦点的字段.
    private enum FocusedField: Hashable {
        case name, url, websocketUrl
    }
    
    /// 检查用户是否已输入任何信息.
    private var hasUserInput: Bool {
        return avatar != nil || name != nil || url != nil || websocketUrl != nil
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            
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
                    errorMessage: isNameEmpty && focusedField == .name ? "昵称不能为空, 请输入昵称并重试." : nil,
                    onTextChange: {
                        checkName(isStrict: false)
                    }
                )
                .focused($focusedField, equals: .name)
                
                StyledPlaceholderTextField(
                    "请输入流媒体视频源",
                    text: $url,
                    placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
                    errorMessage: isStreamingInvalid && focusedField == .url
                    ? "流媒体视频源为空或者不合法, 请重新输入视频源并重试."
                    : nil,
                    onTextChange: {
                        validateStreaming(isStrict: false)
                    }
                )
                .focused($focusedField, equals: .url)
                
                StyledPlaceholderTextField(
                    "请输入WebSocket服务地址",
                    text: $websocketUrl,
                    placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
                    errorMessage: isWebSocketInvalid  && focusedField == .websocketUrl
                    ? "WebSocket服务地址为空或者不合法, 请重新输入地址并重试."
                    : nil,
                    onTextChange: {
                        validateWebSocket(isStrict: false)
                    }
                )
                .focused($focusedField, equals: .websocketUrl)
                
                HStack(spacing: 0, content: {
                    Button(action: handleLogin, label: {
                        Text("加入")
                            .frame(width: hasUserInput ? 170 : 350, height: 50)
                    })
                    .buttonStyle(LoginButtonStyle())
                    .padding(
                        EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: hasUserInput ? 5 : 10)
                    )
                    
                    if hasUserInput {
                        Button(action: clearInput, label: {
                            Text("清空")
                                .frame(width: 170, height: 50)
                        })
                        .buttonStyle(ClearButtonStyle())
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 10))
                        .transition(.move(edge: .trailing))
                    }
                })
                .animation(.easeInOut(duration: 1), value: hasUserInput)
            }
            
            VStack {
                Spacer()
                
                Text("Copyright © 2024 Steve R. Sun")
                    .copyright()
            }
        }
    }
    
    private func checkName(isStrict: Bool = true) {
        if isStrict {
            if let name = name?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
               !name.isEmpty {
                isNameEmpty = false
            } else {
                isNameEmpty = true
            }
        } else {
            /// 避免用户修改昵称清空重新输入时被立刻判定为空.
            if let name = name, !name.isEmpty {
                checkName(isStrict: true)
            } else {
                isNameEmpty = false
            }
        }
    }
    
    private func clearInput() {
        let keys = ["avatar", "name", "url", "websocketUrl"]
        
        keys.forEach({
            /// 删除键值.
            UserDefaults.standard.removeObject(forKey: "LoginView.\($0)")
        })
    }
    
    private func handleLogin() {
        /// 检查昵称是否为空.
        checkName()

        /// 检查流媒体视频源是否合法.
        validateStreaming()
        
        /// 检查WebSocket服务地址是否合法.
        validateWebSocket()
        
        /// 设置焦点位置.
        if isNameEmpty {
            focusedField = .name
        } else if isStreamingInvalid {
            focusedField = .url
        } else if isWebSocketInvalid {
            focusedField = .websocketUrl
        }
        
        if !isNameEmpty && !isStreamingInvalid && !isWebSocketInvalid {
            user.avatar = avatar
            user.name = name!
            streaming.updateURL(
                URL(string: url!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            )
            
            /// 添加自己的用户信息.
            friendsViewModel.addFriend(friend: user)
            
            initWebSocket()
            
            /// 设置登录状态.
            withAnimation(.linear(duration: 0.3), {
                isLoggedIn = true
            })
        }
    }
    
    private func initWebSocket() {
        websocketClient.connect(websocketUrl!, user)
        
        websocketClient.on(eventName: "addFriend", listener: friendsViewModel.addFriend(friend:))
        websocketClient.on(eventName: "offlineFriend", listener: friendsViewModel.offlineFriend(by:))
    }
    
    private func validateStreaming(isStrict: Bool = true) {
        if isStrict {
            if let url = url?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
               let url = URL(string: url), url.scheme != nil, url.host() != nil,
               url.scheme == "http" || url.scheme == "https" {
                isStreamingInvalid = false
            } else {
                isStreamingInvalid = true
            }
        } else {
            /// 避免用户刚输入部分流媒体视频源就被判定为不合法,
            /// `https://`有8个字符, 所以从输入第9个开始检查).
            if let url = url, url.count >= 9 {
                validateStreaming(isStrict: true)
            } else {
                isStreamingInvalid = false
            }
        }
    }
    
    private func validateWebSocket(isStrict: Bool = true) {
        if isStrict {
            if let url = websocketUrl?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
               let url = URL(string: url), url.scheme != nil, url.host() != nil,
               url.scheme == "ws" || url.scheme == "wss", url.path().hasSuffix("/ws/") {
                isWebSocketInvalid = false
            } else {
                isWebSocketInvalid = true
            }
        } else {
            /// 避免用户刚输入部分WebSocket服务地址就被判定为不合法,
            /// `wss://`有6个字符, 所以从输入第7个开始检查).
            if let url = websocketUrl, url.count >= 7 {
                validateWebSocket(isStrict: true)
            } else {
                isWebSocketInvalid = false
            }
        }
    }
}

#Preview {
    let user = User(nil, "")
    let friendsViewModel = FriendsViewModel()
    let streaming = Streaming(url: URL(string: "about:blank")!)
    let websocketClient = WebSocketClient()
    
    LoginView(isLoggedIn: .constant(false))
        .environment(user)
        .environment(friendsViewModel)
        .environment(streaming)
        .environment(websocketClient)
}
