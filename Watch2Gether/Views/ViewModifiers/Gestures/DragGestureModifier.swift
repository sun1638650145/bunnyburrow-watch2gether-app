//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DragGestureModifier.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/16.
//

import SwiftUI

/// `DragGestureModifier`是一个用于识别滑动手势的视图修饰符.
struct DragGestureModifier: ViewModifier {
    /// 识别到滑动手势变化时调用的闭包.
    var changedAction: (DragGesture.Value) -> Void

    /// 识别到滑动手势结束时调用的闭包.
    var endedAction: (DragGesture.Value) -> Void

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
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

    let rectSize: CGFloat = 120
    let vStackSize: CGFloat = 300

    VStack {
        VStack(spacing: 0, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(isBlue ? Color.blue.gradient : Color.indigo.gradient)
                .frame(width: rectSize, height: rectSize)
                .offset(offset)
                .modifier(DragGestureModifier(changedAction: { gesture in
                    offset = gesture.translation

                    /// 计算目标范围.
                    let xRange = rectSize * -0.1 ... rectSize * 0.1
                    let yRange = (vStackSize - rectSize) * 0.9  ... (vStackSize - rectSize) * 1.1

                    if xRange.contains(offset.width) && yRange.contains(offset.height) {
                        isBlue = false
                    } else {
                        isBlue = true
                    }
                }, endedAction: { _ in }))
                .shadow(radius: 5)

            Spacer()

            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .frame(width: rectSize, height: rectSize)
        })
        .frame(width: vStackSize, height: vStackSize)
        .padding(20)

        Text("将矩形移动到虚线框中")
            .font(.headline)
            .foregroundStyle(.primary)
    }
}
