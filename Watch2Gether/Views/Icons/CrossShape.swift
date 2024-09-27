//
//  CrossShape.swift
//  Watch2Gether
//
//  Created by 孙瑞琦 on 2024/9/27.
//

import CoreGraphics
import SwiftUI

/// `CrossShape`用于绘制十字图案.
struct CrossShape: Shape {
    /// 十字图案的宽度.
    let width: Double
    
    /// 十字图案的高度.
    let height: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        /// 添加水平放置的圆角矩形.
        path.addRoundedRect(
            in: CGRect(
                origin: CGPoint(x: (rect.width - width) / 2, y: (rect.height - height) / 2),
                size: CGSize(width: width, height: height)
            ),
            cornerSize: CGSize(width: height / 2, height: height / 2)
        )
        
        /// 添加垂直放置的圆角矩形.
        path.addRoundedRect(
            in: CGRect(
                origin: CGPoint(x: (rect.width - height) / 2, y: (rect.height - width) / 2),
                size: CGSize(width: height, height: width)
            ),
            cornerSize: CGSize(width: height / 2, height: height / 2)
        )
        
        return path
    }
}

#Preview {
    CrossShape(width: 100, height: 10)
}
