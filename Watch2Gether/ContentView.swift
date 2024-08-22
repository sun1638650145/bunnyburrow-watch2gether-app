//
//  ContentView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/3.
//

import SwiftUI

struct ContentView: View {
    /// 登陆状态.
    @State private var isLoggedIn = false
    /// 用户信息.
    @State private var user: User?
    
    var body: some View {
        ZStack {
            // TODO: 在Mac Catalyst上会被错误的忽略安全区域(Steve).
            #if os(iOS)
            Color(hex: "#1A1D29")
                .ignoresSafeArea()
            #elseif os(macOS)
            Color(hex: "#1A1D29")
            #endif
            
            if isLoggedIn {
                HomeView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn, user: $user)
            }
        }
    }
}

#Preview {
    ContentView()
}
