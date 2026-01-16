//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
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

    /// 键盘隐藏时的底部间距, 用于避免主页指示器(Home Indicator)遮挡.
    private let keyboardRestBottomInset: CGFloat

    /// 底部的间距, 键盘隐藏时使用`keyboardRestBottomInset`, 键盘显示时使用键盘的高度.
    private var bottomInset: CGFloat {
        return keyboardHeight == 0.0 ? keyboardRestBottomInset : keyboardHeight
    }

    init(keyboardRestBottomInset: CGFloat) {
        self.keyboardRestBottomInset = keyboardRestBottomInset
    }

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
            /// 根据计算得到的底部间距调整视图, 避免被主页指示器(Home Indicator)或键盘遮挡.
            .padding(.bottom, bottomInset)
    }
}
