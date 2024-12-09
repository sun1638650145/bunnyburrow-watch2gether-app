//
//  HomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import SwiftUI

struct HomeView: View {
    /// 全屏状态.
    @State private var isFullScreen = false
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            
            if isFullScreen {
                VideoPlayer(isFullScreen: $isFullScreen)
                    .transition(.scale(scale: 1.1))
            } else {
                GeometryReader(content: { geometry in
                    VStack(spacing: 0, content: {
                        VideoPlayer(isFullScreen: $isFullScreen)
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
