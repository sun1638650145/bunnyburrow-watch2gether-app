//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  LoginButtonStyle.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/15.
//

import SwiftUI

/// `LoginButtonStyle`是加入按钮的样式.
struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            /// 扩大点击区域.
            .contentShape(Capsule())
            .font(.title2)
            .foregroundStyle(Color.foreground)
            .glassEffectCompat(tintColor: .loginButtonBackground, isInteractive: true)
            .multilineTextAlignment(.center)
            .tracking(5)
    }
}

#Preview {
    Button(action: {
        // ...
    }, label: {
        Text("加入")
            .frame(width: 150, height: 50)
    })
    .buttonStyle(LoginButtonStyle())
    .padding(10)
}
