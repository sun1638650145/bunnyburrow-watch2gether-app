//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  VersionTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/5.
//

import Testing
@testable import Watch2Gether

struct VersionTests {
    @Test
    func compareEqualVersions() {
        let lhs = Version(major: 1, minor: 2, patch: 3)
        let rhs = Version(major: 1, minor: 2, patch: 3)

        #expect(lhs == rhs)
    }

    @Test("按照优先级比较语义化版本", arguments: [
        (Version(major: 1, minor: 0, patch: 0), Version(major: 2, minor: 0, patch: 0), true),
        (Version(major: 1, minor: 0, patch: 0), Version(major: 1, minor: 1, patch: 0), true),
        (Version(major: 1, minor: 1, patch: 0), Version(major: 1, minor: 1, patch: 1), true),
        (Version(major: 2, minor: 0, patch: 0), Version(major: 1, minor: 0, patch: 0), false)
    ])
    func compareVersions(lhs: Version, rhs: Version, expectedIsLessThan: Bool) {
        #expect((lhs < rhs) == expectedIsLessThan)
    }

    @Test
    func convertVersionToDescriptionString() {
        let version = Version(major: 2026, minor: 3, patch: 5)

        #expect(version.description == "2026.3.5")
    }
}
