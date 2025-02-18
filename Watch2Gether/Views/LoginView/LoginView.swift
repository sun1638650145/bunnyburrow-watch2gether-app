//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  LoginView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
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
                    errorMessage: isNameEmpty && focusedField == .name ? "昵称不能为空, 请输入昵称并重试." : nil,
                    onTextChange: {
                        checkName(strictMode: false)
                    }
                )
                .focused($focusedField, equals: .name)

                StyledPlaceholderTextField(
                    "请输入流媒体视频源",
                    text: $url,
                    placeholderColor: .textFieldPlaceholder,
                    errorMessage: isStreamingInvalid && focusedField == .url ? "流媒体视频源为空或者不合法, 请重新输入视频源并重试." : nil,
                    onTextChange: {
                        validateStreaming(strictMode: false)
                    }
                )
                .focused($focusedField, equals: .url)

                StyledPlaceholderTextField(
                    "请输入WebSocket服务地址",
                    text: $websocketUrl,
                    placeholderColor: .textFieldPlaceholder,
                    errorMessage: isWebSocketInvalid && focusedField == .websocketUrl
                    ? "WebSocket服务地址为空或者不合法, 请重新输入地址并重试."
                    : nil,
                    onTextChange: {
                        validateWebSocket(strictMode: false)
                    }
                )
                .focused($focusedField, equals: .websocketUrl)

                HStack(spacing: 0, content: {
                    Button(action: handleLogin, label: {
                        Text("加入")
                            .frame(width: hasUserInput ? 170 : 350, height: 50)
                    })
                    .buttonStyle(LoginButtonStyle())
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: hasUserInput ? 5 : 10))

                    if hasUserInput {
                        Button(action: clearUserInput, label: {
                            Text("清空")
                                .frame(width: 170, height: 50)
                        })
                        .buttonStyle(ClearButtonStyle())
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 10))
                        .transition(.move(edge: .trailing))
                    }
                })
                .animation(.linear(duration: 0.8), value: hasUserInput)
            }

            VStack {
                Spacer()

                Text("Copyright © 2025 Steve R. Sun")
                    .copyright()
            }
            .ignoresSafeArea(.keyboard)
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

    /// 清空用户输入的所有信息.
    private func clearUserInput() {
        let keys = ["avatar", "name", "url", "websocketUrl"]

        keys.forEach({
            /// 删除键值.
            UserDefaults.standard.removeObject(forKey: "LoginView.\($0)")
        })
    }

    /// 处理登录操作.
    private func handleLogin() {
        checkName()
        validateStreaming()
        validateWebSocket()

        /// 设置焦点位置.
        if isNameEmpty {
            focusedField = .name
        } else if isStreamingInvalid {
            focusedField = .url
        } else if isWebSocketInvalid {
            focusedField = .websocketUrl
        } else {
            user.update(avatar, name!)
            streamingViewModel.updateURL(URL(string: url!.trimmingCharacters(in: .whitespacesAndNewlines))!)
            setupWebSocketConnection()

            /// 添加自己的用户信息.
            friendsViewModel.addFriend(friend: user)

            /// 校验通过, 设置登录状态.
            withAnimation(.linear(duration: 0.3), {
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
            .ignoresSafeArea()

        LoginView()
            .environment(appSettings)
            .environment(user)
            .environment(friendsViewModel)
            .environment(streamingViewModel)
            .environment(webSocketClient)
    }
}
