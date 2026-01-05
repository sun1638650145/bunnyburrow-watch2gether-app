//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
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
        ZStack {
            Color.background
                .hideKeyboard()
                .ignoresSafeArea()

            if appSettings.isPlayerFullScreen {
                VideoPlayer()
                    .hideHomeIndicator()
                    /// 隐藏状态栏.
                    .statusBarHidden(true)
                    .transition(.scale(scale: 1.1))

                DanmakuSpace()
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
                .ignoresSafeArea(.keyboard)
                /// 显示状态栏.
                .statusBarHidden(false)
            }
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User(avatar: nil, clientID: 2025, name: "Steve")
    let messageStoreViewModel = MessageStoreViewModel()
    let playerViewModel = PlayerViewModel(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    let videosViewModel = VideosViewModel()
    let webSocketClient = WebSocketClient()

    var friendsViewModel: FriendsViewModel {
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.addFriend(friend: user)

        return friendsViewModel
    }

    HomeView()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(messageStoreViewModel)
        .environment(playerViewModel)
        .environment(videosViewModel)
        .environment(webSocketClient)
}
