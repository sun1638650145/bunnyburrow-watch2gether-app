//
//  LoginButton.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/8.
//

import SwiftUI

struct LoginButton: View {
    @Binding var isLoggedIn: Bool
    let name: String?
    
    /// 按钮悬停状态.
    @State private var isHovered = false

    /// 按钮按压状态.
    @State private var isPressed = false
    
    init(_ isLoggedIn: Binding<Bool>, name: String?) {
        self._isLoggedIn = isLoggedIn
        self.name = name
    }
    
    var body: some View {
        Button(action: {
            /// 昵称不为空时, 设置登陆状态.
            if let name = name, !name.isEmpty {
                isLoggedIn = true
            }
        }, label: {
            Text("加入")
                .frame(width: 350, height: 50)
        })
        .background(
            Group {
                /// 在iOS上按下按钮时, 使用90%的透明度.
                #if os(iOS)
                isPressed ? Color(hex: "#0682F0").opacity(0.9) : Color(hex: "#0682F0")
                #elseif os(macOS)
                Color(hex: "#0682F0")
                #endif
            }
        )
        .bold()
        /// 在macOS上光标悬停时, 使用110%的亮度.
        .brightness(isHovered ? 0.1 : 0)
        .buttonStyle(PlainButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .font(.title2)
        .foregroundStyle(Color(hex: "#F9F9F9"))
        .onHover(perform: { hovering in
            isHovered = hovering
        })
        .onLongPressGesture(perform: {}, onPressingChanged: { pressing in
            isPressed = pressing
        })
        .padding(10)
        .tracking(5)
    }
}

#Preview {
    @State var isLoggedIn = false
    let name = ""
    
    return LoginButton($isLoggedIn, name: name)
}
