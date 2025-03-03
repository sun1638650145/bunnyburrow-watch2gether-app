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
    @Previewable @State var isBlue: Bool = true

    VStack {
        RoundedRectangle(cornerRadius: 20)
            .fill(isBlue ? Color.blue.gradient : Color.indigo.gradient)
            .frame(width: 200, height: 200)
            .modifier(DoubleTapGesture(action: {
                isBlue.toggle()
            }))
            .shadow(radius: 5)
            .padding(10)

        Text("双击矩形切换颜色")
            .font(.headline)
            .foregroundStyle(.primary)
    }
}
