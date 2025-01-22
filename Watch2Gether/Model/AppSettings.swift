//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AppSettings.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/12/21.
//

import Observation

/// 应用设置状态信息.
@Observable
class AppSettings {
    /// 状态信息: 激活`ImagePicker`后会提示登录页面禁用(灰白色遮罩), 须优先上传头像.
    #if os(macOS)
    var isImagePickerActive: Bool = false
    #endif

    /// 状态信息: 视频播放器全屏状态.
    var isFullScreen: Bool = false

    /// 状态信息: 登录状态.
    var isLoggedIn: Bool = false
}
