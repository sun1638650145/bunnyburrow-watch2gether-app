//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  HomeView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/11.
//

import Foundation
import SwiftUI

/// `HomeView`是主界面视图, 用于显示视频播放器, 好友列表和聊天界面.
struct HomeView: View {
    @Environment(AppSettings.self) var appSettings

    var body: some View {
        GeometryReader(content: { geometry in
            if appSettings.isFullScreen {
                VideoPlayer()
                    .transition(.scale(scale: 1.1))
            } else {
                HStack(spacing: 0, content: {
                    VideoPlayer()
                        /// 固定视频播放器的宽度为窗口的2/3.
                        .frame(width: geometry.size.width * 2/3)

                    VStack(spacing: 0, content: {
                        FriendsList()

                        ConversationSpace()
                    })
                })
            }
        })
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User(avatar: nil, clientID: 2025, name: "Steve")
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/oceans/")!)
    let webSocketClient = WebSocketClient()

    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.addFriend(friend: user)

        return friendsViewModel
    }

    ZStack {
        Color.background

        HomeView()
            .environment(appSettings)
            .environment(user)
            .environment(friendsViewModel)
            .environment(streamingViewModel)
            .environment(webSocketClient)
    }
    .frame(width: 800, height: 600)
}
