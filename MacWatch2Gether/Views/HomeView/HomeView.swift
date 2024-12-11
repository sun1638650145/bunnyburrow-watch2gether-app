//
//  HomeView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import AVKit
import SwiftUI

struct HomeView: View {
    @Environment(StreamingViewModel.self) var streamingViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
            
            if streamingViewModel.isFullScreen {
                VideoPlayer()
            } else {
                GeometryReader(content: { geometry in
                    HStack(spacing: 0, content: {
                        VideoPlayer()
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
