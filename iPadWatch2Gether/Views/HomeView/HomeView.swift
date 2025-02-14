//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  HomeView.swift
//  iPadWatch2Gether
//
//  Created by Steve R. Sun on 2025/1/5.
//

import Foundation
import SwiftUI

/// `HomeView`是主界面视图, 用于显示视频播放器, 好友列表和聊天界面.
struct HomeView: View {
    @Environment(AppSettings.self) var appSettings

    var body: some View {
        if appSettings.isFullScreen {
            VideoPlayer()
                .transition(.scale(scale: 1.1))
        } else {
            GeometryReader(content: { geometry in
                if geometry.size.width > geometry.size.height {
                    /// 设置横向布局.
                    HStack(spacing: 0, content: {
                        VideoPlayer()
                            /// 固定视频播放器的宽度为窗口的70%.
                            .frame(width: geometry.size.width * 0.7)

                        VStack(spacing: 0, content: {
                            FriendsList()

                            ConversationSpace()
                        })
                    })
                } else {
                    /// 设置纵向布局.
                    VStack(spacing: 0, content: {
                        VideoPlayer()
                            /// 固定视频播放器的高度为窗口的45%.
                            .frame(height: geometry.size.height * 0.45)

                        FriendsList()

                        ConversationSpace()
                    })
                }
            })
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User(avatar: nil, clientID: 2025, name: "Steve")
    let streamingViewModel = StreamingViewModel(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let webSocketClient = WebSocketClient()

    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.addFriend(friend: user)

        return friendsViewModel
    }

    ZStack {
        Color.background
            .ignoresSafeArea()

        HomeView()
            .environment(appSettings)
            .environment(user)
            .environment(friendsViewModel)
            .environment(streamingViewModel)
            .environment(webSocketClient)
    }
}
