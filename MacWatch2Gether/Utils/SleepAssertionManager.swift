//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  SleepAssertionManager.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/4/17.
//

import Foundation
import IOKit.pwr_mgt

/// 系统休眠状态管理器, 通过使用`IOKit`的电源管理系统接口, 阻止或恢复系统休眠.
class SleepAssertionManager {
    /// 断言ID, 用于跟踪电源管理状态.
    private var assertionID: IOPMAssertionID = 0

    /// 允许系统进入休眠状态.
    func enableSleep() {
        let result = IOPMAssertionRelease(assertionID)
        
        if result == kIOReturnSuccess {
            print("启用系统休眠.")
        }
    }

    /// 阻止系统进入休眠状态.
    ///
    /// - Parameters:
    ///   - reason: 用于描述和设置断言的原因.
    func preventSleep(with reason: String) {
        /// 向电源管理系统(power management system)请求系统行为.
        let result = IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason as CFString,
            &assertionID
        )
        
        if result == kIOReturnSuccess {
            print("阻止系统休眠.")
        }
    }
}
