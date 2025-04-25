//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Version.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/4/25.
//

/// 语义化版本(Semantic Versioning), 格式为`major.minor.patch`.
struct Version: Comparable, CustomStringConvertible {
    /// 主版本号.
    var major: UInt

    /// 次版本号.
    var minor: UInt

    /// 修订号.
    var patch: UInt

    /// 遵循`CustomStringConvertible`协议要求.
    var description: String {
        return "\(major).\(minor).\(patch)"
    }

    /// 遵循`Comparable`协议要求.
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else {
            return lhs.patch < rhs.patch
        }
    }
}
