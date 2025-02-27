//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DoubleTapGesture.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/27.
//

import SwiftUI

/// `DoubleTapGesture`是一个用于触发双击手势的视图修饰符.
struct DoubleTapGesture: ViewModifier {
    /// 双击手势触发时调用的闭包.
    var action: () -> Void

    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2, perform: {
                action()
            })
    }
}

#Preview {
    Button(action: {
        // ...
    }, label: {
        Text("请尝试双击按钮")
    })
    .modifier(DoubleTapGesture(action: {
        print("按钮被双击.")
    }))
}
