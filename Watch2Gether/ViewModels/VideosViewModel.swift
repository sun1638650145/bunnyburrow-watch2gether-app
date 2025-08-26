//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideosViewModel.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/8/26.
//

import Foundation
import Observation

import SwiftyJSON

/// 流媒体视频播放列表视图模型.
@Observable
class VideosViewModel {
    /// 可供选择的流媒体视频播放列表.
    var videos: [String] = []

    /// 获取流媒体视频列表.
    ///
    /// - Parameters:
    ///   - domainUrl: 流媒体服务器的域名URL.
    /// - Returns: 流媒体视频列表.
    /// - Throws: 当网络请求或数据解析失败时抛出异常.
    func fetchVideos(from domainUrl: URL) async throws -> [String] {
        /// 拼接完整的请求URL.
        let videosUrl = domainUrl
            .appending(path: "videos", directoryHint: .isDirectory)
            .appending(queryItems: [URLQueryItem(name: "sort", value: "true")])

        let (data, response) = try await URLSession.shared.data(from: videosUrl)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {
            // TODO: 为快速实现功能暂未处理异常(Steve).
            return []
        }

        return JSON(data)["videos"].arrayValue.map({ $0.stringValue })
    }
}
