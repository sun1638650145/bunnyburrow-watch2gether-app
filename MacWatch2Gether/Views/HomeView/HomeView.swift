//
//  HomeView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import SwiftUI

struct HomeView: View {
    @Environment(Streaming.self) var streaming
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
            
            GeometryReader(content: { geometry in
                HStack(spacing: 0, content: {
                    VideoPlayer(url: streaming.url)
                        /// 固定视频播放器的宽度为窗口的70%.
                        .frame(width: geometry.size.width * 0.7)
                    
                    VStack(spacing: 0, content: {
                        FriendsList()
                        
                        ChatRoom()
                    })
                })
            })
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
