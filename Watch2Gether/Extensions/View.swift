//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  View.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/8.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

extension View {
    /// 为`View`添加版权信息的样式.
    ///
    /// - Returns: 应用`copyright`样式后的视图.
    func copyright() -> some View {
        self.modifier(Copyright())
    }

    /// 为`View`添加键盘自适应的功能(只适用于`iOS`平台).
    ///
    /// - Returns: 应用`keyboardAdaptive`后的视图.
    #if os(iOS)
    func keyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptive())
    }
    #endif

    /// 为`View`添加识别到双击手势时执行的操作.
    ///
    /// - Parameters:
    ///   - action: 识别到双击手势时调用的闭包.
    /// - Returns: 应用`onDoubleTapGesture`后的视图.
    func onDoubleTapGesture(perform action: @escaping () -> Void) -> some View {
        self.modifier(DoubleTapGesture(action: action))
    }

    /// 检测设备旋转并执行相应的操作(只适用于`iOS`平台).
    ///
    /// - Parameters:
    ///   - action: 设备旋转时调用的闭包.
    /// - Returns: 应用`onRotate`后的视图.
    #if os(iOS)
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotation(action: action))
    }
    #endif
}
