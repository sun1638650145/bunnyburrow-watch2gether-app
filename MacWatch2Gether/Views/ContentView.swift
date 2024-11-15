//
//  ContentView.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/7.
//

import SwiftUI

struct ContentView: View {
    /// 登录状态.
    @State private var isLoggedIn = false
    
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
    let user = User(nil, "")
    let streaming = Streaming(url: URL(string: "about:blank")!)
    
    ContentView()
        .environment(user)
        .environment(streaming)
}
