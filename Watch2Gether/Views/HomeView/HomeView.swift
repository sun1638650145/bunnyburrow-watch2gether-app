//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  HomeView.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/8/22.
//

import Foundation
import SwiftUI

/// `HomeView`是主界面视图, 用于显示视频播放器, 好友列表和聊天界面.
struct HomeView: View {
    @Environment(AppSettings.self) var appSettings

    var body: some View {
        Group {
            if appSettings.isFullScreen {
                VideoPlayer()
                    .transition(.scale(scale: 1.1))
            } else {
                GeometryReader(content: { geometry in
                    VStack(spacing: 0, content: {
                        VideoPlayer()
                            /// 固定视频播放器的高度为屏幕的1/3.
                            .frame(height: geometry.size.height / 3)

                        FriendsList()

                        ConversationSpace()
                    })
                })
            }
        }
        /// 检测设备旋转自动设置视频播放器全屏.
        .onRotate(perform: { orientation in
            if orientation == .portrait {
                appSettings.isFullScreen = false
            } else if orientation.isLandscape {
                appSettings.isFullScreen = true
            }
        })
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User(avatar: nil, clientID: 2023, name: "Steve")
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
