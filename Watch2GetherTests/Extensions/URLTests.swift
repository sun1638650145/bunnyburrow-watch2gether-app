//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  URLTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/7/16.
//

import Foundation
import Testing

@testable import Watch2Gether

struct URLTests {
    @Test("获取域名URL", arguments: [
        (URL(string: "https://example.com/video/")!, "https://example.com/"),
        (URL(string: "http://127.0.0.1:8000/path?query=value#fragment")!, "http://127.0.0.1:8000/")
    ])
    func domainURL(value: URL, expected: String) {
        #expect(value.domainURL?.absoluteString == expected)
    }

    @Test("获取域名URL失败", arguments: [
        URL(string: "/video/")!
    ])
    func domainURLWithoutHost(value: URL) {
        #expect(value.domainURL == nil)
    }
}
