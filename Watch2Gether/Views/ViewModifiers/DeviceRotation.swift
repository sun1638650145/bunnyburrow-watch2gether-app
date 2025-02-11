//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  DeviceRotation.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2025/2/11.
//

import Foundation
import SwiftUI
import UIKit

/// `DeviceRotation`是一个用于检测设备旋转的视图修饰符.
struct DeviceRotation: ViewModifier {
    /// 设备旋转时调用的闭包.
    var action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(
                NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification),
                perform: { _ in
                    action(UIDevice.current.orientation)
                }
            )
    }
}

#Preview {
    @Previewable @State var orientationString = "未知"

    Text("设备的当前方向是: \(orientationString)")
        .modifier(DeviceRotation(action: { orientation in
            switch orientation {
            case .portrait:
                orientationString = "纵向模式, 顶部朝上"
            case .portraitUpsideDown:
                orientationString = "纵向模式, 顶部朝下"
            case .landscapeLeft:
                orientationString = "横向模式, 音量按钮朝下"
            case .landscapeRight:
                orientationString = "横向模式, 音量按钮朝上"
            case .faceUp:
                orientationString = "设备平放, 屏幕朝上"
            case .faceDown:
                orientationString = "设备平放, 屏幕朝下"
            default:
                orientationString = "未知"
            }
        }))
}
