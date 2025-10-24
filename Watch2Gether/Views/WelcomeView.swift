//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  WelcomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/10/22.
//

import SwiftUI

/// `WelcomeView`是快速登录视图, 当用户信息存在时, 用户可直接进入主界面.
struct WelcomeView: View {
    /// 用户的头像的Base-64.
    @AppStorage("Account.avatar") private var avatar: String = ""

    /// 用户的昵称.
    @AppStorage("Account.name") private var name: String = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: {
                    // ...
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.foreground)
                })
                .padding(20)
            }

            Spacer()
        }

        VStack {
            Text("Welcome back, \(name)!")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color.foreground)

            Image(base64: avatar)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .glassEffectCompat()
        }

        VStack {
            Spacer()

            if #available(iOS 26.0, *) {
                Button(action: {
                    // ...
                }, label: {
                    Text("Login")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(Color.foreground)
                        .frame(width: 125, height: 36)
                        .multilineTextAlignment(.center)
                        .tracking(5)
                })
                .buttonStyle(GlassProminentButtonStyle())
                .padding(20)
            } else {
                Button(action: {
                    // ...
                }, label: {
                    Text("Login")
                        .frame(width: 150, height: 50)
                })
                .buttonStyle(LoginButtonStyle(isCapsuleShape: true))
                .padding(20)
            }

            Text("Copyright © 2025 Steve R. Sun")
                .copyright()
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()

        WelcomeView()
    }
}
