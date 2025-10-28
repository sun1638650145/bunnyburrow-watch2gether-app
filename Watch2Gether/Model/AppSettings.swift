//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AppSettings.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/21.
//

import Foundation
import Observation

/// 应用设置状态信息.
@Observable
class AppSettings {
    /// 状态信息: 成功登录应用后被设置为已认证状态, 应用再次启动时显示`WelcomeView`而不是`LoginView`.
    var hasAuthenticated: Bool {
        get { UserDefaults.standard.bool(forKey: "Auth.hasAuthenticated") }
        set { UserDefaults.standard.set(newValue, forKey: "Auth.hasAuthenticated") }
    }

    /// 状态信息: 激活`NSOpenPanel`后会提示当前页面禁用(灰白色遮罩), 须优先上传或者选择文件.
    #if os(macOS)
    var isPanelActive: Bool = false
    #endif

    /// 状态信息: 视频播放器全屏状态.
    var isFullScreen: Bool = false

    /// 状态信息: 登录状态.
    var isLoggedIn: Bool = false

    /// 显示弹幕聊天消息输入视图.
    var showDanmakuMessageInput: Bool = false
}
