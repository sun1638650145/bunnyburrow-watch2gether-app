//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DoubleTapGesture.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/27.
//

import SwiftUI

/// `DoubleTapGesture`是一个用于识别双击手势的视图修饰符.
struct DoubleTapGesture: ViewModifier {
    /// 识别到双击手势时调用的闭包.
    var action: () -> Void

    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2, perform: {
                action()
            })
    }
}

#Preview {
    Text("请尝试双击文本")
        .modifier(DoubleTapGesture(action: {
            print("文本被双击.")
        }))
}
