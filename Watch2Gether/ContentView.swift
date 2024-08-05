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
            Color(hex: "#1A1D29")
            
            if isLoggedIn {
                // ...
            } else {
                LoginView(isLoggedIn: $isLoggedIn, user: $user)
            }
        }
    }
}

#Preview {
    ContentView()
}
