//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  WelcomeView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/11/1.
//

import SwiftUI

/// `WelcomeView`是快速登录视图, 当用户信息存在时, 用户可直接进入主界面.
struct WelcomeView: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(User.self) var user
    @Environment(FriendsViewModel.self) var friendsViewModel
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(WebSocketClient.self) var webSocketClient

    /// 用户的头像的Base-64.
    @AppStorage("Account.avatar") private var avatar: String = ""

    /// 用户的昵称.
    @AppStorage("Account.name") private var name: String = ""

    /// 视频源URL.
    @AppStorage("Server.url") private var url: String?

    /// WebSocket服务地址.
    @AppStorage("Server.webSocketUrl") private var webSocketUrl: String?

    /// 动画持续的时间(秒).
    private var duration: Double = 1

    var body: some View {
        ZStack {
            Color.background

            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation(.linear(duration: duration), {
                            appSettings.hasAuthenticated = false
                        })
                    }, label: {
                        Image(systemName: "ellipsis")
                            .frame(width: 35, height: 35)
                            /// 扩大点击区域.
                            .contentShape(Circle())
                            .foregroundStyle(Color.foreground)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .glassEffectCompat()
                    .padding(15)
                }

                Spacer()
            }

            VStack {
                Text("Welcome back, \(name)!")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.foreground)

                Image(base64: avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .glassEffectCompat()
            }

            VStack {
                Spacer()

                Button(action: handleLogin, label: {
                    Text("Login")
                        .frame(width: 150, height: 50)
                })
                .buttonStyle(LoginButtonStyle())
                .padding(20)

                Text("Copyright © 2026 Steve R. Sun")
                    .copyright()
                    .padding(5)
            }
        }
    }

    /// 处理登录操作.
    private func handleLogin() {
        user.update(avatar, name)
        playerViewModel.updateURL(URL(string: url!)!)
        webSocketClient.setupConnection(webSocketUrl!, user, with: friendsViewModel)

        /// 添加自己的用户信息.
        friendsViewModel.addFriend(friend: user)

        /// 设置登录状态.
        withAnimation(.linear(duration: duration), {
            appSettings.isLoggedIn = true
        })
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let playerViewModel = PlayerViewModel()
    let webSocketClient = WebSocketClient()

    WelcomeView()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(playerViewModel)
        .environment(webSocketClient)
        .frame(width: 800, height: 600)
}
