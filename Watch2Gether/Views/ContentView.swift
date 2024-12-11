//
//  ContentView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool

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
    @Previewable @State var isLoggedIn = false
    
    let user = User(nil, "")
    let friendsViewModel = FriendsViewModel()
    let streamingViewModel = StreamingViewModel(url: URL(string: "about:blank")!)
    let websocketClient = WebSocketClient()
    
    ContentView(isLoggedIn: $isLoggedIn)
        .environment(user)
        .environment(friendsViewModel)
        .environment(streamingViewModel)
        .environment(websocketClient)
}
