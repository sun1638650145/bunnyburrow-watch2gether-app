//
//  HomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import AVKit
import SwiftUI

struct HomeView: View {
    @Environment(Streaming.self) var streaming
    
    /// 全屏状态.
    @State private var isFullScreen = false
    
    /// `AVPlayer`播放器加载并控制视频播放.
    var player: AVPlayer {
        return AVPlayer(url: streaming.url)
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            
            if isFullScreen {
                VideoPlayer(player: player, isFullScreen: $isFullScreen)
            } else {
                GeometryReader(content: { geometry in
                    VStack(spacing: 0, content: {
                        VideoPlayer(player: player, isFullScreen: $isFullScreen)
                            /// 固定视频播放器的高度为屏幕的1/3.
                            .frame(height: geometry.size.height / 3)
                        
                        FriendsList()
                        
                        ChatRoom()
                    })
                })
            }
        }
    }
}

#Preview {
    let user = User(nil, "")
    let friendsViewModel = FriendsViewModel()
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let websocketClient = WebSocketClient()
    
    HomeView()
        .environment(user)
        .environment(friendsViewModel)
        .environment(streaming)
        .environment(websocketClient)
}
