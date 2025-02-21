//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  AppDelegate.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/12/15.
//

import AVKit
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    /// 配置音频会话.
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            /// 设置音频会话在静音或屏幕锁定仍然继续播放.
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        } catch {
            print("设置音频会话配置失败: \(error.localizedDescription)")
        }
    }

    /// 控制屏幕方向锁定, 默认为竖屏.
    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            UIApplication.shared.connectedScenes.forEach({ scene in
                if let scene = scene as? UIWindowScene {
                    /// 更新场景方向.
                    scene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))

                    /// 更新根视图控制器方向.
                    if let viewController = scene.keyWindow?.rootViewController {
                        viewController.setNeedsUpdateOfSupportedInterfaceOrientations()
                    }
                }
            })
        }
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureAudioSession()

        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
