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
            .simultaneousGesture(
                MagnifyGesture()
                    .onEnded({ value in
                        value.magnification < 1.0 ? scaleDownAction() : scaleUpAction()
                    })
            )
    }
}

#Preview {
    @Previewable @State var scale: CGFloat = 1.0

    VStack {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.blue.gradient)
            .frame(width: 200, height: 200)
            .modifier(ScaleGesture(scaleDownAction: {
                withAnimation(.default, {
                    scale *= 0.8
                })
            }, scaleUpAction: {}))
            .padding(10)
            .scaleEffect(scale)
            .shadow(radius: scale * 5)

        VStack {
            Text("捏合手势")
                .font(.headline)
                .foregroundStyle(.primary)

            Text("当前比例: \(String(format: "%.1f", scale))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
