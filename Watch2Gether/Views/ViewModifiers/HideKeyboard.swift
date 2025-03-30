//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  HideKeyboard.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/30.
//

import SwiftUI
import UIKit

/// `HideKeyboard`是隐藏键盘的视图修饰符, 用户通过点击使键盘隐藏.
struct HideKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture(perform: {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
                )
            })
    }
}
