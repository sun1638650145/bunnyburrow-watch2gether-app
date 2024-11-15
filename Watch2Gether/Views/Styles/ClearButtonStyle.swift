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
            .background(
                /// 按下按钮时, 使用90%的透明度.
                Color(hex: "#FF554C").opacity(configuration.isPressed ? 0.9 : 1)
            )
            .bold()
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title2)
            .foregroundStyle(Color(hex: "#F9F9F9"))
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
