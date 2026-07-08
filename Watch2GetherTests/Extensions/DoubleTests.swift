//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  DoubleTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/7/8.
//

import Testing

@testable import Watch2Gether

struct DoubleTests {
    @Test("将时间格式化为播放时间字符串", arguments: [
        (0.0, "00:00"),
        (1.0, "00:01"),
        (59.0, "00:59"),
        (60.0, "01:00"),
        (3599.0, "59:59"),
        (3600.0, "01:00:00")
    ])
    func formattedTime(value: Double, expected: String) {
        #expect(value.formattedTime() == expected)
    }

    @Test("将非有限时间格式化为默认播放时间字符串", arguments: [
        Double.infinity,
        Double.nan
    ])
    func formattedTimeForNonFinite(value: Double) {
        #expect(value.formattedTime() == "00:00")
    }
}
