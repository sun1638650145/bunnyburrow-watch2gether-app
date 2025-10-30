//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  WelcomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/10/22.
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
    @AppStorage("Server.websocketUrl") private var websocketUrl: String?

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        // ...
                    }, label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.foreground)
                            .frame(width: 40, height: 40)
                    })
                    .padding(5)
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

                if #available(iOS 26.0, *) {
                    Button(action: handleLogin, label: {
                        Text("Login")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(Color.foreground)
                            .frame(width: 125, height: 36)
                            .multilineTextAlignment(.center)
                            .tracking(5)
                    })
                    .buttonStyle(GlassProminentButtonStyle())
                    .padding(20)
                } else {
                    Button(action: handleLogin, label: {
                        Text("Login")
                            .frame(width: 150, height: 50)
                    })
                    .buttonStyle(LoginButtonStyle(isCapsuleShape: true))
                    .padding(20)
                }

                Text("Copyright © 2025 Steve R. Sun")
                    .copyright()
            }
        }
    }

    /// 处理登录操作.
    private func handleLogin() {
        user.update(avatar, name)
        playerViewModel.updateURL(URL(string: url!)!)
        setupWebSocketConnection()

        /// 添加自己的用户信息.
        friendsViewModel.addFriend(friend: user)

        /// 设置登录状态.
        withAnimation(.linear(duration: 0.3), {
            appSettings.isLoggedIn = true
        })
    }

    /// 配置WebSocket连接.
    private func setupWebSocketConnection() {
        webSocketClient.connect(websocketUrl!, user)

        webSocketClient.on(eventName: "addFriend", listener: friendsViewModel.addFriend(friend:))
        webSocketClient.on(eventName: "hasFriend", listener: { (clientID: UInt) -> Bool in
            return friendsViewModel.searchFriend(by: clientID) != nil
        })
        webSocketClient.on(eventName: "offlineAllFriends", listener: friendsViewModel.offlineAllFriends)
        webSocketClient.on(eventName: "offlineFriend", listener: friendsViewModel.offlineFriend(by:))
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let playerViewModel = PlayerViewModel()
    let webSocketClient = WebSocketClient()

    ZStack {
        Color.background
            .ignoresSafeArea()

        WelcomeView()
            .environment(appSettings)
            .environment(user)
            .environment(friendsViewModel)
            .environment(playerViewModel)
            .environment(webSocketClient)
    }
}
