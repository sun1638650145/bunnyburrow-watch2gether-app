//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Watch2GetherApp.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

@main
struct Watch2GetherApp: App {
    /// 将`AppDelegate`添加到SwiftUI应用中.
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    /// 当前的生命周期状态.
    @Environment(\.scenePhase) private var scenePhase

    /// 应用设置状态信息.
    @State private var appSettings = AppSettings()

    /// 用户信息.
    @State private var user = User()

    /// 好友信息视图模型.
    @State private var friendsViewModel = FriendsViewModel()

    /// 流媒体视频视图模型.
    @State private var streamingViewModel = StreamingViewModel()

    /// WebSocket客户端.
    @State private var webSocketClient = WebSocketClient()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appSettings)
                .environment(user)
                .environment(friendsViewModel)
                .environment(streamingViewModel)
                .environment(webSocketClient)
                .focusedSceneValue(appSettings)
                .focusedSceneValue(user)
                .focusedSceneValue(streamingViewModel)
                .focusedSceneValue(webSocketClient)
        }
        .commands(content: {
            PlaybackControlsCommands()
        })
        /// 监听应用的生命周期状态.
        .onChange(of: scenePhase, { oldPhase, newPhase in
            if oldPhase == .background && newPhase == .inactive {
                /// 当应用从后台变为非活跃状态时, 重新建立WebSocket连接.
                webSocketClient.reconnect()
            } else if newPhase == .background {
                /// 进入后台时, 断开与WebSocket服务器的连接.
                webSocketClient.disconnect()
            }
        })
    }
}
