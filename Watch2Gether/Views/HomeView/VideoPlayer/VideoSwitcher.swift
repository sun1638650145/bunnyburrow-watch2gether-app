//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoSwitcher.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/8/23.
//

import Foundation
import SwiftUI

import SwiftyJSON

/// `VideoSwitcher`是视频切换菜单, 用于在多个视频之间进行切换.
struct VideoSwitcher: View {
    @Environment(StreamingViewModel.self) var streamingViewModel

    /// 可供选择的视频列表.
    @State private var videos: [String] = []

    var body: some View {
        Menu(content: {
            if videos.isEmpty {
                Text("Loading...")
            } else {
                ForEach(videos, id: \.self, content: { video in
                    Button(action: {
                        streamingViewModel.switchTo(named: video)
                    }, label: {
                        Text(video)
                    })
                })
            }
        }, label: {
            Text("Switch Video")
                .bold()
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
        .task({
            do {
                videos = try await self.fetchVideos(from: streamingViewModel.domainUrl)
            } catch {
                print("获取流媒体视频列表失败: \(error.localizedDescription)")
            }
        })
    }

    /// 获取流媒体视频列表.
    ///
    /// - Parameters:
    ///   - domainUrl: 流媒体服务器的域名URL.
    /// - Returns: 流媒体视频列表.
    /// - Throws: 当网络请求或数据解析失败时抛出异常.
    private func fetchVideos(from domainUrl: URL) async throws -> [String] {
        /// 拼接完整的请求URL.
        let videosUrl = domainUrl.appending(path: "videos", directoryHint: .isDirectory)

        let (data, response) = try await URLSession.shared.data(from: videosUrl)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {
            // TODO: 为快速实现功能暂未处理异常(Steve).
            return []
        }

        return JSON(data)["videos"].arrayValue.map({ $0.stringValue })
    }
}

#Preview {
    let streamingViewModel = StreamingViewModel()

    VideoSwitcher()
        .environment(streamingViewModel)
}
