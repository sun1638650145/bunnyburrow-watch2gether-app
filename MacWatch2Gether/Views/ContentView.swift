//
//  ContentView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1D29")
            
            if isLoggedIn {
                HomeView()
                    .frame(minWidth: 800, minHeight: 600)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .frame(minWidth: 600, minHeight: 600)
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
