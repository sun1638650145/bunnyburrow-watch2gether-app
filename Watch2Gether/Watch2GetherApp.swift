//
//  Watch2GetherApp.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

@main
struct Watch2GetherApp: App {
    /// 当前的生命周期状态.
    @Environment(\.scenePhase) private var scenePhase
    
    /// 用户信息.
    @State private var user = User(nil, "")
    
    /// 好友信息视图模型.
    @State private var friendsViewModel = FriendsViewModel()
    
    /// 流媒体视频视图模型.
    @State private var streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    
    /// WebSocket客户端.
    @State private var websocketClient = WebSocketClient()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(user)
                .environment(friendsViewModel)
                .environment(streamingViewModel)
                .environment(websocketClient)
        }
        /// 监听App关闭, 主动断开WebSocket连接.
        .onChange(of: scenePhase, { oldPhase, newPhase in
            // TODO: 目前不能保持在后台中不断开(Steve).
            if newPhase == .background {
                websocketClient.disconnect()
            }
        })
    }
}
