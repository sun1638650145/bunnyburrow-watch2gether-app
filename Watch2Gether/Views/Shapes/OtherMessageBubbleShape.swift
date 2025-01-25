//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  OtherMessageBubbleShape.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2025/1/25.
//

import CoreGraphics
import SwiftUI

/// `OtherMessageBubbleShape`用于绘制其他用户的聊天消息气泡形状.
struct OtherMessageBubbleShape: Shape {
    /// 气泡的圆角半径.
    var cornerRadius: CGFloat = 10.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + cornerRadius * 3 / 2, y: rect.minY))

        /// 绘制顶部边和右上圆角.
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius * 3 / 2, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius / 2, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX - cornerRadius / 2, y: rect.minY)
        )

        /// 绘制右侧边和右下圆角.
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius / 2, y: rect.maxY - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius * 3 / 2, y: rect.maxY),
            control: CGPoint(x: rect.maxX - cornerRadius / 2, y: rect.maxY)
        )

        /// 绘制底部边和左下圆角.
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius * 3 / 2, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius / 2, y: rect.maxY - cornerRadius),
            control: CGPoint(x: rect.minX + cornerRadius / 2, y: rect.maxY)
        )

        /// 绘制左侧边(包括尖角部分).
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius / 2, y: rect.minY + cornerRadius * 5 / 2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius * 2))
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius / 2, y: rect.minY + cornerRadius * 3 / 2))
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius / 2, y: rect.minY + cornerRadius))

        /// 绘制左上圆角.
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius * 3 / 2, y: rect.minY),
            control: CGPoint(x: rect.minX + cornerRadius / 2, y: rect.minY)
        )

        return path
    }
}

#Preview {
    Text("一条消息")
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        .background(Color.otherMessageBubbleBackground)
        .clipShape(OtherMessageBubbleShape())
        .foregroundStyle(Color.foreground)
}
