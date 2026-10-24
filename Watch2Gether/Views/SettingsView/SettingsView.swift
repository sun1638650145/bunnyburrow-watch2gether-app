//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  SettingsView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2026/10/23.
//

import SwiftUI

/// `SettingsView`是设置视图.
struct SettingsView: View {
    @Environment(User.self) var user

    /// 用户的头像的Base-64.
    @AppStorage("Account.avatar") private var avatar: String?

    var body: some View {
        VStack {
            Text("Watch2Gether")
                .bold()
                .font(.largeTitle)

            AvatarUploader($avatar)
                .onChange(of: avatar, {
                    user.update(avatar)
                })
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    let user = User()

    SettingsView()
        .environment(user)
}
