//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ContentView.swift
//  MacWatch2Gether
//
//  Create by Steve R. Sun on 2024/11/7.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppSettings.self) var appSettings

    var body: some View {
        ZStack {
            Color.background

            if appSettings.isLoggedIn {
                HomeView()
            } else {
                LoginView()
                    .transition(.move(edge: .top))
                    .zIndex(1)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let streamingViewModel = StreamingViewModel()
    let webSocketClient = WebSocketClient()

    ContentView()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(streamingViewModel)
        .environment(webSocketClient)
}
