//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  VideosViewModelTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/1.
//

import Foundation
import Testing

import SwiftyJSON

@testable import Watch2Gether

struct VideosViewModelTests {
    init() {
        /// 注册`MockURLProtocol`, 用于拦截并模拟`URLSession`的网络请求.
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    @Test
    func fetchVideosSucceeds() async throws {
        let videos = ["flower", "oceans"]
        MockURLProtocol.json = JSON(["videos": videos])

        let videosViewModel = VideosViewModel()
        let url = URL(string: "https://example.com")

        try await videosViewModel.fetchVideos(from: url!)

        #expect(videosViewModel.videos == videos)
    }
}
