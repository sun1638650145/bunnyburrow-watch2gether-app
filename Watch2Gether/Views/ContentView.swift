//
//  ContentView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

struct ContentView: View {
    /// 登录状态.
    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            
            if isLoggedIn {
                HomeView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .transition(.move(edge: .top))
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    let user = User(nil, "")
    let friendsManager = FriendsManager()
    let streaming = Streaming(url: URL(string: "about:blank")!)
    let websocketClient = WebSocketClient()
    
    ContentView()
        .environment(user)
        .environment(friendsManager)
        .environment(streaming)
        .environment(websocketClient)
}
