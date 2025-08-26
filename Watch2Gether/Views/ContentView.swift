//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ContentView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppSettings.self) var appSettings

    var body: some View {
        ZStack {
            Color.background
                .hideKeyboard()
                .ignoresSafeArea()

            if appSettings.isLoggedIn {
                HomeView()
            } else {
                LoginView()
                    .transition(.move(edge: .top))
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    let appSettings = AppSettings()
    let user = User()
    let friendsViewModel = FriendsViewModel()
    let messageStoreViewModel = MessageStoreViewModel()
    let playerViewModel = PlayerViewModel()
    let webSocketClient = WebSocketClient()

    ContentView()
        .environment(appSettings)
        .environment(user)
        .environment(friendsViewModel)
        .environment(messageStoreViewModel)
        .environment(playerViewModel)
        .environment(webSocketClient)
}
