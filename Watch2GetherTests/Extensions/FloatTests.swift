//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  FloatTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/7/9.
//

import Testing

@testable import Watch2Gether

struct FloatTests {
    @Test("格式化播放速率为字符串", arguments: [
        (0.5, "0.5"),
        (0.75, "0.75"),
        (1.0, "1"),
        (1.25, "1.25"),
        (1.5, "1.5"),
        (2.0, "2")
    ])
    func formattedPlaybackRate(value: Float, expected: String) {
        #expect(value.formattedPlaybackRate() == expected)
    }
}
