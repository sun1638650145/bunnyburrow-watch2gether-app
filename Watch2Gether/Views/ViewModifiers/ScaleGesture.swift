//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ScaleGesture.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/1.
//

import SwiftUI

/// `ScaleGesture`是一个用于识别缩放(包括缩小和放大)手势的视图修饰符.
struct ScaleGesture: ViewModifier {
    /// 识别到缩小手势时调用的闭包.
    var scaleDownAction: () -> Void

    /// 识别到放大手势时调用的闭包.
    var scaleUpAction: () -> Void

    func body(content: Content) -> some View {
        content
            .gesture(MagnifyGesture()
                .onEnded({ value in
                    if value.magnification < 1.0 {
                        scaleDownAction()
                    } else {
                        scaleUpAction()
                    }
                })
            )
    }
}

#Preview {
    @Previewable @State var scale: CGFloat = 1.0

    VStack {
        Rectangle()
            .foregroundStyle(Color.blue)
            .frame(width: 200, height: 200)
            .modifier(ScaleGesture(scaleDownAction: {
                withAnimation(.default, {
                    scale *= 0.8
                })
            }, scaleUpAction: {}))
            .padding(10)
            .scaleEffect(scale)

        Text("请捏合方块")
    }
}
