//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Watch2GetherApp.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

#if os(macOS)
import AppKit
#endif
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

    /// 用于存储聊天消息的视图模型.
    @State private var messageStoreViewModel = MessageStoreViewModel()

    /// 流媒体播放器视图模型.
    @State private var playerViewModel = PlayerViewModel()

    /// 流媒体视频播放列表视图模型.
    @State private var videosViewModel = VideosViewModel()

    /// WebSocket客户端.
    @State private var webSocketClient = WebSocketClient()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appSettings)
                .environment(user)
                .environment(friendsViewModel)
                .environment(messageStoreViewModel)
                .environment(playerViewModel)
                .environment(videosViewModel)
                .environment(webSocketClient)
                .focusedSceneValue(appSettings)
                .focusedSceneValue(user)
                .focusedSceneValue(playerViewModel)
                .focusedSceneValue(webSocketClient)
                #if os(macOS)
                .onAppear(perform: {
                    /// 监听应用窗口进入全屏的通知.
                    NotificationCenter.default.addObserver(
                        forName: NSWindow.didEnterFullScreenNotification,
                        object: nil,
                        queue: nil,
                        using: { _ in
                            appSettings.isWindowFullScreen = true
                        }
                    )

                    /// 监听应用窗口退出全屏的通知.
                    NotificationCenter.default.addObserver(
                        forName: NSWindow.didExitFullScreenNotification,
                        object: nil,
                        queue: nil,
                        using: { _ in
                            appSettings.isWindowFullScreen = false
                        }
                    )
                })
                #endif
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
        /// 在macOS上隐藏标题栏.
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
