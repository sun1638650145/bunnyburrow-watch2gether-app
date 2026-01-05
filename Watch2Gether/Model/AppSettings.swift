//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  AppSettings.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/21.
//

#if os(macOS)
import AppKit
#endif
import Foundation
import Observation

/// 应用设置状态信息.
@Observable
class AppSettings {
    /// 状态信息: 成功登录应用后被设置为已认证状态, 应用再次启动时显示`WelcomeView`而不是`LoginView`.
    @ObservationIgnored
    var hasAuthenticated: Bool {
        get {
            /// 通知`Observation`, `hasAuthenticated`被访问时, 注册依赖关系, 使观察该属性的视图在值变化时自动刷新.
            access(keyPath: \.hasAuthenticated)

            return UserDefaults.standard.bool(forKey: "Auth.hasAuthenticated")
        }
        set {
            /// 通知`Observation`, `hasAuthenticated`的值即将变化, 在闭包执行完成后, 通知观察该属性的视图刷新.
            withMutation(keyPath: \.hasAuthenticated, {
                UserDefaults.standard.set(newValue, forKey: "Auth.hasAuthenticated")
            })
        }
    }

    /// 状态信息: 登录状态.
    var isLoggedIn: Bool = false

    #if os(macOS)
    /// 状态信息: 激活`NSOpenPanel`后会提示当前页面禁用(灰白色遮罩), 须优先上传或者选择文件.
    var isPanelActive: Bool = false

    /// 状态信息: 应用窗口全屏状态.
    var isWindowFullScreen: Bool = false {
        didSet {
            updateCursorState()
        }
    }
    #endif

    /// 状态信息: 视频播放器全屏状态.
    var isPlayerFullScreen: Bool = false {
        didSet {
            #if os(macOS)
            updateCursorState()
            #endif
        }
    }

    /// 显示弹幕聊天消息输入视图.
    var showDanmakuMessageInput: Bool = false

    #if os(macOS)
    /// 用于自动隐藏光标的定时器.
    private var hideCursorTimer: Timer = Timer()

    /// 鼠标事件监视器.
    private var mouseEventMonitor: Any?

    /// 重置隐藏光标的定时器.
    private func resetHideCursorTimer() {
        /// 取消已有的定时器.
        self.hideCursorTimer.invalidate()

        self.hideCursorTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in
            NSCursor.hide()
        })
    }

    /// 根据当前全屏状态更新光标状态.
    private func updateCursorState() {
        /// 需要视频播放器和应用窗口均处于全屏状态.
        if isPlayerFullScreen && isWindowFullScreen {
            /// 5秒钟后, 自动隐藏光标.
            self.resetHideCursorTimer()

            /// 当鼠标移动时, 重新显示光标.
            mouseEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .mouseMoved, handler: { _ in
                NSCursor.unhide()

                /// 鼠标停止移动5秒钟后, 再次自动隐藏光标.
                self.resetHideCursorTimer()

                return nil
            })
        } else {
            NSCursor.unhide()

            /// 移除鼠标事件监视器.
            if let eventMonitor = mouseEventMonitor {
                NSEvent.removeMonitor(eventMonitor)
                mouseEventMonitor = nil
            }

            /// 取消已有的定时器.
            self.hideCursorTimer.invalidate()
        }
    }
    #endif
}
