//
//  LoginButtonStyle.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/15.
//

import SwiftUI

/// `LoginButtonStyle`是加入按钮的样式.
struct LoginButtonStyle: ButtonStyle {
    /// 按钮悬停状态.
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                /// 在iOS上按下按钮时, 使用90%的透明度; 在macOS上光标悬停时, 使用110%的亮度.
                Group {
                    #if os(iOS)
                    Color(hex: "#0682F0").opacity(configuration.isPressed ? 0.9 : 1)
                    #elseif os(macOS)
                    Color(hex: "#0682F0").brightness(isHovered ? 0.1 : 0)
                    #endif
                }
            )
            .bold()
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title2)
            .foregroundStyle(Color(hex: "#F9F9F9"))
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
