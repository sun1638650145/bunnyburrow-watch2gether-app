//
//  HomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(Streaming.self) var streaming
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            
            GeometryReader(content: { geometry in
                VStack(spacing: 0, content: {
                    VideoPlayer(url: streaming.url)
                        /// 固定视频播放器的高度为屏幕的1/3.
                        .frame(height: geometry.size.height / 3)
                    
                    FriendsList()
                    
                    /// 用于临时模拟聊天室组件.
                    Color.blue
                        .ignoresSafeArea()
                })
            })
        }
    }
}

#Preview {
    let friendsManager = FriendsManager()
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    HomeView()
        .environment(friendsManager)
        .environment(streaming)
}
