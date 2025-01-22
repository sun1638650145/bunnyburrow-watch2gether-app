//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  LoginButtonStyle.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/8/15.
//

import SwiftUI

/// `LoginButtonStyle`是加入按钮的样式.
struct LoginButtonStyle: ButtonStyle {
    /// 按钮悬停状态.
    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Group {
                    /// 在iOS上按下按钮时, 使用90%的透明度.
                    #if os(iOS)
                    Color.loginButtonBackground.opacity(configuration.isPressed ? 0.9 : 1)

                    /// 在macOS上光标悬停时, 使用110%的亮度.
                    #elseif os(macOS)
                    Color.loginButtonBackground.brightness(isHovered ? 0.1 : 0)
                    #endif
                }
            )
            .bold()
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title2)
            .foregroundStyle(Color.foreground)
            .multilineTextAlignment(.center)
            #if os(macOS)
            .onHover(perform: { hovering in
                isHovered = hovering
            })
            #endif
            .tracking(5)
    }
}

#Preview {
    Button(action: {
        // ...
    }, label: {
        Text("加入")
            .frame(width: 350, height: 50)
    })
    .buttonStyle(LoginButtonStyle())
    .padding(10)
}
