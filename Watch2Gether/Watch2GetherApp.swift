//
//  Watch2GetherApp.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

@main
struct Watch2GetherApp: App {
    /// 用户信息.
    @State private var user = User(nil, "")
    
    /// 流媒体视频源.
    @State private var streaming = Streaming(url: URL(string: "about:blank")!)
    
    /// WebSocket客户端.
    @State private var websocketClient = WebSocketClient()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(user)
                .environment(streaming)
                .environment(websocketClient)
        }
    }
}
