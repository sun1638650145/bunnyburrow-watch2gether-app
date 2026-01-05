//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  SimultaneousDragGesture.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/3/16.
//

import SwiftUI

/// `SimultaneousDragGesture`是一个用于同时识别滑动手势的视图修饰符.
struct SimultaneousDragGesture: ViewModifier {
    /// 识别到滑动手势变化时调用的闭包.
    var changedAction: (DragGesture.Value) -> Void

    /// 识别到滑动手势结束时调用的闭包.
    var endedAction: (DragGesture.Value) -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        changedAction(value)
                    })
                    .onEnded({ value in
                        endedAction(value)
                    })
            )
    }
}

#Preview {
    @Previewable @State var isBlue: Bool = true
    @Previewable @State var offset: CGSize = .zero

    let hStackSize: CGFloat = 250
    let rectSize: CGFloat = 100

    VStack {
        HStack(spacing: 0, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(isBlue ? Color.blue.gradient : Color.indigo.gradient)
                .frame(width: rectSize, height: rectSize)
                .offset(offset)
                .modifier(SimultaneousDragGesture(changedAction: { gesture in
                    offset = gesture.translation

                    /// 计算目标范围.
                    let xRange = (hStackSize - rectSize) * 0.9 ... (hStackSize - rectSize) * 1.1
                    let yRange = rectSize * -0.1 ... rectSize * 0.1

                    if xRange.contains(offset.width) && yRange.contains(offset.height) {
                        isBlue = false
                    } else {
                        isBlue = true
                    }
                }, endedAction: { _ in }))
                .shadow(radius: 5)

            Spacer()

            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                .frame(width: rectSize, height: rectSize)
        })
        .frame(width: hStackSize, height: hStackSize)

        Text("将矩形移动到虚线框中")
            .font(.headline)
            .foregroundStyle(.primary)
    }
    .padding(10)
}
