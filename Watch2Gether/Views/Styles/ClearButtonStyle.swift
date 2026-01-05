//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  ClearButtonStyle.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/6.
//

import SwiftUI

/// `ClearButtonStyle`是清空按钮的样式.
struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            /// 扩大点击区域.
            .contentShape(Capsule())
            .font(.title2)
            .foregroundStyle(Color.foreground)
            .glassEffectCompat(tintColor: .alertError, isInteractive: true)
            .multilineTextAlignment(.center)
            .tracking(5)
    }
}

#Preview {
    Button(action: {
        // ...
    }, label: {
        Text("清空")
            .frame(width: 150, height: 50)
    })
    .buttonStyle(ClearButtonStyle())
}
