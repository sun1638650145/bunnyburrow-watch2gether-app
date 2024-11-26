//
//  SendButtonStyle.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/26.
//

#if os(macOS)
import AppKit
#endif
import SwiftUI

/// `SendButtonStyle`是发送按钮的样式.
struct SendButtonStyle: ButtonStyle {
    /// 是否禁用按钮.
    var isDisabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#095AE6"), Color(hex: "#062794")]),
                    /// 左侧中点.
                    startPoint: UnitPoint(x: 0, y: 0.5),
                    /// 右侧中点`UnitPoint(x: 1, y: 0.5)`往下3.87deg:
                    /// 计算方式, 因为坐标原点在左上角, 所以右侧中点并不是CSS中的90deg, 而是90deg - 90deg,
                    /// 因此93.87deg就是正半轴的3.87deg, 最后角度转换成弧度后归一化到[0, 1]区间.
                    endPoint: UnitPoint(
                        x: cos((93.87 - 90) * .pi / 180) * 0.5 + 0.5,
                        y: sin((93.87 - 90) * .pi / 180) * 0.5 + 0.5
                    )
                )
            )
            .bold()
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .disabled(isDisabled)
            .foregroundStyle(Color(hex: "#E5E7EB"))
            .grayscale(isDisabled ? 0.3 : 0)
            #if os(macOS)
            .onHover(perform: { hovering in
                /// 在悬停且禁用按钮时使用不能执行光标.
                if hovering && isDisabled {
                    NSCursor.operationNotAllowed.push()
                } else {
                    NSCursor.pop()
                }
            })
            #endif
            .tracking(2)
    }
}

#Preview("启用发送按钮") {
    Button(action: {
        // ...
    }, label: {
        Text("发送")
            .frame(width: 100, height: 35)
    })
    .buttonStyle(SendButtonStyle())
    .padding(10)
}

#Preview("禁用发送按钮") {
    Button(action: {
        // ...
    }, label: {
        Text("发送")
            .frame(width: 100, height: 35)
    })
    .buttonStyle(SendButtonStyle(isDisabled: true))
    .padding(10)
}
