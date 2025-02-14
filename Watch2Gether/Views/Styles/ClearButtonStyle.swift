//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
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
            .background(Color.alertError.opacity(configuration.isPressed ? 0.9 : 1))
            .bold()
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title2)
            .foregroundStyle(Color.foreground)
            .multilineTextAlignment(.center)
            .tracking(5)
    }
}

#Preview {
    Button(action: {
        // ...
    }, label: {
        Text("清空")
            .frame(width: 350, height: 50)
    })
    .buttonStyle(ClearButtonStyle())
}
