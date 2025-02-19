//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  KeyboardAdaptive.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/2/19.
//

import Combine
import CoreGraphics
import Foundation
import SwiftUI
import UIKit

/// `KeyboardAdaptive`是键盘自适应的视图修饰符, 用于动态调整视图底部间距, 避免键盘遮挡视图.
struct KeyboardAdaptive: ViewModifier {
    /// 用于存储键盘事件监听器的取消器集合.
    @State private var cancellables = Set<AnyCancellable>()

    /// 当前键盘的高度.
    @State private var keyboardHeight: CGFloat = 0.0

    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                /// 监听键盘显示之前的通知.
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                    /// 确保键盘尺寸的数据类型为`CGRect`.
                    .compactMap({ notification in
                        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    })

                    /// 获取到键盘尺寸后, 将高度保存到`keyboardHeight`.
                    .sink(receiveValue: { rect in
                        withAnimation(.easeInOut, {
                            self.keyboardHeight = rect.height
                        })
                    })

                    /// 将键盘显示事件监听器保存到取消器集合中.
                    .store(in: &cancellables)

                /// 监听键盘隐藏之前的通知.
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    /// 将键盘高度重置.
                    .sink(receiveValue: { _ in
                        withAnimation(.easeInOut, {
                            self.keyboardHeight = 0.0
                        })
                    })

                    /// 将键盘隐藏事件监听器保存到取消器集合中.
                    .store(in: &cancellables)
            })
            /// 根据键盘的高度调整视图底部的间距.
            .padding(.bottom, keyboardHeight)
    }
}
