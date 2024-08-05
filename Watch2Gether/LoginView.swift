//
//  LoginView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var user: User?
    
    var body: some View {
        VStack {
            Text("一起看电影")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color(hex: "#F9F9F9"))
                .padding(10)
            
            AvatarUploader()
        }
    }
}

#Preview {
    @State var isLoggedIn = false
    @State var user: User?
    
    return LoginView(isLoggedIn: $isLoggedIn, user: $user)
}
