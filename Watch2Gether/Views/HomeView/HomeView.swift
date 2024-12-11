//
//  HomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(StreamingViewModel.self) var streamingViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            
            if streamingViewModel.isFullScreen {
                VideoPlayer()
                    .transition(.scale(scale: 1.1))
            } else {
                GeometryReader(content: { geometry in
                    VStack(spacing: 0, content: {
                        VideoPlayer()
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
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    let websocketClient = WebSocketClient()
    
    HomeView()
        .environment(user)
        .environment(friendsViewModel)
        .environment(streamingViewModel)
        .environment(websocketClient)
}
