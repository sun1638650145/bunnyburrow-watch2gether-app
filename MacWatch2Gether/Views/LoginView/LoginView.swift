//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  LoginView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import Foundation
import SwiftUI

/// `LoginView`是登录页面视图, 允许用户输入基本信息, 视频源URL和WebSocket服务地址.
struct LoginView: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(User.self) var user
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(StreamingViewModel.self) var streamingViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 用户的头像的Base-64.
    @AppStorage("LoginView.avatar") private var avatar: String?

    /// 用户的昵称.
    @AppStorage("LoginView.name") private var name: String?

    /// 视频源URL.
    @AppStorage("LoginView.url") private var url: String?

    /// WebSocket服务地址.
    @AppStorage("LoginView.websocketUrl") private var websocketUrl: String?

    /// 昵称为空变量.
    @State private var isNameEmpty = false

    /// 流媒体视频源不合法状态变量.
    @State private var isStreamingInvalid = false

    /// WebSocket服务地址不合法状态变量.
    @State private var isWebSocketInvalid = false

    var body: some View {
        ZStack {
            VStack {
                Text("一起看电影")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.foreground)
                    .padding(10)

                AvatarUploader($avatar)

                StyledPlaceholderTextField(
                    "请输入昵称",
                    text: $name,
                    placeholderColor: .textFieldPlaceholder,
                    errorMessage: isNameEmpty ? "昵称不能为空, 请输入昵称并重试." : nil,
                    onTextChange: {
                        checkName(strictMode: false)
                    }
                )

                StyledPlaceholderTextField(
                    "请输入流媒体视频视频源",
                    text: $url,
                    placeholderColor: .textFieldPlaceholder,
                    errorMessage: isStreamingInvalid ? "流媒体视频源为空或者不合法, 请重新输入视频源并重试." : nil,
                    onTextChange: {
                        validateStreaming(strictMode: false)
                    }
                )

                StyledPlaceholderTextField(
                    "请输入WebSocket服务地址",
                    text: $websocketUrl,
                    placeholderColor: .textFieldPlaceholder,
                    errorMessage: isWebSocketInvalid ? "WebSocket服务地址为空或者不合法, 请重新输入地址并重试." : nil,
                    onTextChange: {
                        validateWebSocket(strictMode: false)
                    }
                )

                Button(action: handleLogin, label: {
                    Text("加入")
                        .frame(width: 350, height: 50)
                })
                .buttonStyle(LoginButtonStyle())
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
            }

            VStack {
                Spacer()

                Text("Copyright © 2025 Steve R. Sun")
                    .copyright()
                    .padding(5)
            }

            if appSettings.isImagePickerActive {
                Color.white
                    .opacity(0.3)
            }
        }
    }

    /// 检查昵称是否为空.
    ///
    /// - Parameters:
    ///   - strictMode: 严格模式, 如果为`true`, 则立刻检查是否为空.
    private func checkName(strictMode: Bool = true) {
        if strictMode {
            if let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
                isNameEmpty = false
            } else {
                isNameEmpty = true
            }
        } else {
            /// 避免用户修改昵称清空重新输入时被立刻判定为空.
            if let name = name, !name.isEmpty {
                checkName(strictMode: true)
            } else {
                isNameEmpty = false
            }
        }
    }

    /// 处理登录操作.
    private func handleLogin() {
        checkName()
        validateStreaming()
        validateWebSocket()

        if !isNameEmpty && !isStreamingInvalid && !isWebSocketInvalid {
            user.update(avatar, name!)
            streamingViewModel.updateURL(URL(string: url!.trimmingCharacters(in: .whitespacesAndNewlines))!)
            setupWebSocketConnection()

            /// 添加自己的用户信息.
            friendsViewModel.addFriend(friend: user)

            /// 设置登录状态.
            withAnimation(.linear(duration: 1), {
                appSettings.isLoggedIn = true
            })
        }
    }

    /// 配置WebSocket连接.
    private func setupWebSocketConnection() {
        webSocketClient.connect(websocketUrl!, user)

        webSocketClient.on(eventName: "addFriend", listener: friendsViewModel.addFriend(friend:))
        webSocketClient.on(eventName: "offlineAllFriends", listener: friendsViewModel.offlineAllFriends)
        webSocketClient.on(eventName: "offlineFriend", listener: friendsViewModel.offlineFriend(by:))
    }

    /// 校验流媒体视频源是否合法.
    ///
    /// - Parameters:
    ///   - strictMode: 严格模式, 如果为`true`, 则立刻校验是否合法.
    private func validateStreaming(strictMode: Bool = true) {
        if strictMode {
            if let url = url?.trimmingCharacters(in: .whitespacesAndNewlines), let url = URL(string: url),
               url.scheme == "http" || url.scheme == "https", url.host() != nil {
                isStreamingInvalid = false
            } else {
                isStreamingInvalid = true
            }
        } else {
            /// 避免用户刚输入部分流媒体视频源就被判定为不合法, `https://`有8个字符, 所以输入从第9个开始校验.
            if let url = url, url.count >= 9 {
                validateStreaming(strictMode: true)
            } else {
                isStreamingInvalid = false
            }
        }
    }

    /// 校验WebSocket服务地址是否合法.
    ///
    /// - Parameters:
    ///   - strictMode: 严格模式, 如果为`true`, 则立刻校验是否合法.
    private func validateWebSocket(strictMode: Bool = true) {
        if strictMode {
            if let url = websocketUrl?.trimmingCharacters(in: .whitespacesAndNewlines), let url = URL(string: url),
               url.scheme == "ws" || url.scheme == "wss", url.host() != nil, url.path().hasSuffix("/ws/") {
                isWebSocketInvalid = false
            } else {
                isWebSocketInvalid = true
            }
        } else {
            /// 避免用户刚输入部分WebSocket服务地址就被判定为不合法, `wss://`有6个字符, 所以输入从第7个开始校验.
            if let url = websocketUrl, url.count >= 7 {
                validateWebSocket(strictMode: true)
            } else {
                isWebSocketInvalid = false
            }
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let streamingViewModel = StreamingViewModel()
    let webSocketClient = WebSocketClient()

    ZStack {
        Color.background

        LoginView()
            .environment(appSettings)
            .environment(user)
            .environment(friendsViewModel)
            .environment(streamingViewModel)
            .environment(webSocketClient)
    }
    .frame(width: 800, height: 600)
}
