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
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 用户的头像的Base-64.
    @AppStorage("Account.avatar") private var avatar: String?

    /// 用户的昵称.
    @AppStorage("Account.name") private var name: String?

    /// 视频源URL.
    @AppStorage("Server.url") private var url: String?

    /// WebSocket服务地址.
    @AppStorage("Server.webSocketUrl") private var webSocketUrl: String?

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
        case name, url, webSocketUrl
    }

    /// 检查用户是否已输入任何信息.
    private var hasUserInput: Bool {
        return avatar != nil || name != nil || url != nil || webSocketUrl != nil
    }

    var body: some View {
        ZStack {
            Color.background
                .hideKeyboard()
                .ignoresSafeArea()

            VStack {
                Text("Watch2Gether")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.foreground)
                    .padding(10)

                AvatarUploader($avatar)

                VStack(spacing: 0, content: {
                    StyledPlaceholderTextField(
                        "Enter your nickname",
                        text: $name,
                        placeholderColor: .textFieldPlaceholder,
                        errorMessage: isNameEmpty && focusedField == .name
                        ? "Nickname cannot be empty. Please try again."
                        : nil,
                        onTextChange: {
                            checkName(strictMode: false)
                        }
                    )
                    .focused($focusedField, equals: .name)

                    StyledPlaceholderTextField(
                        "Enter WebSocket URL",
                        text: $webSocketUrl,
                        placeholderColor: .textFieldPlaceholder,
                        errorMessage: isWebSocketInvalid && focusedField == .webSocketUrl
                        ? "Invalid WebSocket URL. Please try again."
                        : nil,
                        onTextChange: {
                            validateWebSocket(strictMode: false)
                        }
                    )
                    .focused($focusedField, equals: .webSocketUrl)

                    VideoPickerTextField(
                        "Enter streaming URL or select local file",
                        text: $url,
                        placeholderColor: .textFieldPlaceholder,
                        errorMessage: isStreamingInvalid && focusedField == .url
                        ? "Invalid or missing video source. Please try again."
                        : nil,
                        onTextChange: {
                            validateStreaming(strictMode: false)
                        }
                    )
                    .focused($focusedField, equals: .url)
                })

                HStack(spacing: 0, content: {
                    Button(action: handleLogin, label: {
                        Text("Login")
                            .frame(width: hasUserInput ? 170 : 350, height: 50)
                    })
                    .buttonStyle(LoginButtonStyle())
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: hasUserInput ? 5 : 10))

                    if hasUserInput {
                        Button(action: clearUserInput, label: {
                            Text("Clear")
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
        let accountKeys = ["avatar", "name"]
        let serverKeys = ["url", "webSocketUrl"]

        /// 删除键值.
        accountKeys.forEach({
            UserDefaults.standard.removeObject(forKey: "Account.\($0)")
        })
        serverKeys.forEach({
            UserDefaults.standard.removeObject(forKey: "Server.\($0)")
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
        } else if isWebSocketInvalid {
            focusedField = .webSocketUrl
        } else if isStreamingInvalid {
            focusedField = .url
        } else {
            /// 校验通过后, 更新视频源URL和WebSocket服务地址(删除空格和换行符).
            url = url?.trimmingCharacters(in: .whitespacesAndNewlines)
            webSocketUrl = webSocketUrl?.trimmingCharacters(in: .whitespacesAndNewlines)

            user.update(avatar, name!)
            playerViewModel.updateURL(URL(string: url!)!)
            webSocketClient.setupConnection(webSocketUrl!, user, with: friendsViewModel)

            /// 添加自己的用户信息.
            friendsViewModel.addFriend(friend: user)

            /// 设置已认证和登录状态.
            withAnimation(.linear(duration: 0.3), {
                appSettings.hasAuthenticated = true
                appSettings.isLoggedIn = true
            })
        }
    }

    /// 校验流媒体视频源是否合法.
    ///
    /// - Parameters:
    ///   - strictMode: 严格模式, 如果为`true`, 则立刻校验是否合法.
    private func validateStreaming(strictMode: Bool = true) {
        if strictMode {
            if let url = url?.trimmingCharacters(in: .whitespacesAndNewlines), let url = URL(string: url),
               url.isFileURL || url.scheme == "http" || url.scheme == "https",
               /// 如果是文件URL则主机地址可以为nil.
               url.isFileURL || url.host() != nil {
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
            if let url = webSocketUrl?.trimmingCharacters(in: .whitespacesAndNewlines), let url = URL(string: url),
               url.scheme == "ws" || url.scheme == "wss", url.host() != nil, url.path().hasSuffix("/ws/") {
                isWebSocketInvalid = false
            } else {
                isWebSocketInvalid = true
            }
        } else {
            /// 避免用户刚输入部分WebSocket服务地址就被判定为不合法, `wss://`有6个字符, 所以输入从第7个开始校验.
            if let url = webSocketUrl, url.count >= 7 {
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
    let playerViewModel = PlayerViewModel()
    let webSocketClient = WebSocketClient()

    LoginView()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(playerViewModel)
        .environment(webSocketClient)
}
