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

    /// 用户的昵称.
    @AppStorage("Account.name") private var name: String = ""

    var body: some View {
        List(content: {
            Section(content: {
                HStack(content: {
                    Spacer()

                    Text("Watch2Gether")
                        .bold()
                        .font(.largeTitle)

                    Spacer()
                })
                .listRowBackground(Color.clear)
            })

            Section(content: {
                HStack(content: {
                    Spacer()

                    AvatarUploader($avatar)
                        .onChange(of: avatar, {
                            user.updateAvatar(avatar)
                        })

                    Spacer()
                })
                .listRowBackground(Color.clear)
            })

            Section("Personal Information", content: {
                HStack(content: {
                    Text("Name")

                    Spacer()

                    TextField(user.name, text: $name)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: name, {
                            user.updateName(name)
                        })
                })

                HStack(content: {
                    Text("Client ID")

                    Spacer()

                    Text(String(user.clientID))
                })
            })
        })
        .navigationTitle("Settings")
    }
}

#Preview {
    let user = User()

    SettingsView()
        .environment(user)
}
