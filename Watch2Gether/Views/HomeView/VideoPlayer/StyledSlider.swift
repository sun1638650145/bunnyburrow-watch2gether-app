//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  StyledSlider.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2025/2/8.
//

import SwiftUI

/// `StyledSlider`是自定义的样式滑块视图.
struct StyledSlider: View {
    @Binding var value: Double

    /// 有效值的范围.
    private let bounds: ClosedRange<Double>

    /// 滑块的大小.
    private let thumbSize: Double

    /// 滑块拖动完成时调用的闭包.
    private var onEditingEnded: () -> Void

    init(
        value: Binding<Double>,
        in bounds: ClosedRange<Double> = 0...1,
        onEditingEnded: @escaping () -> Void = {},
        thumbSize: Double = 20.0
    ) {
        self._value = value
        self.bounds = bounds
        self.onEditingEnded = onEditingEnded
        self.thumbSize = thumbSize
    }

    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .leading, content: {
                /// 滑轨的背景部分.
                RoundedRectangle(cornerRadius: 2)
                    .foregroundStyle(Color.foreground.opacity(0.2))
                    .frame(width: geometry.size.width, height: 4)

                /// 滑轨的前景部分(经过的部分).
                RoundedRectangle(cornerRadius: 2)
                    .foregroundStyle(Color.foreground)
                    .frame(
                        width: self.calculateThumbPosition(for: geometry.size.width - thumbSize) + thumbSize / 2,
                        height: 4
                    )

                Circle()
                    .foregroundStyle(Color.foreground)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: self.calculateThumbPosition(for: geometry.size.width - thumbSize))
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.updateValue(for: gesture.location.x, trackWidth: geometry.size.width - thumbSize)
                            })
                            .onEnded({ _ in
                                self.onEditingEnded()
                            })
                    )
            })
            /// 扩大点击区域.
            .contentShape(Rectangle())
            .onTapGesture(perform: { location in
                self.updateValue(for: location.x, trackWidth: geometry.size.width - thumbSize)
                self.onEditingEnded()
            })
        })
        .frame(height: thumbSize)
    }

    /// 计算滑块在滑轨上的位置.
    ///
    /// - Parameters:
    ///   - width: 滑轨的宽度.
    /// - Returns: 滑块在滑轨上的位置.
    private func calculateThumbPosition(for width: Double) -> Double {
        /// 进行归一化.
        return (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound) * width
    }

    /// 更新拖动过程中滑块的值.
    ///
    /// - Parameters:
    ///   - locationX: 当前手势位置的水平坐标.
    ///   - trackWidth: 滑轨的宽度.
    private func updateValue(for locationX: Double, trackWidth: Double) {
        /// 进行线性映射.
        var newValue = (bounds.lowerBound + locationX / trackWidth) * (bounds.upperBound - bounds.lowerBound)

        /// 确保值在有效范围内.
        newValue = min(bounds.upperBound, max(newValue, bounds.lowerBound))

        withAnimation(.easeInOut, {
            value = newValue
        })
    }
}

#Preview {
    @Previewable @State var seekPosition: Double = 0.3

    StyledSlider(value: $seekPosition, in: 0...1)
}
