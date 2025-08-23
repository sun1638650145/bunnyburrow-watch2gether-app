//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoSwitcher.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/8/23.
//

import SwiftUI

/// `VideoSwitcher`是视频切换菜单, 用于在多个视频之间进行切换.
struct VideoSwitcher: View {
    /// 可供选择的视频列表.
    private let videos: [String]

    init(videos: [String]) {
        self.videos = videos
    }

    var body: some View {
        Menu(content: {
            ForEach(videos, id: \.self, content: { video in
                Button(action: {
                    // ...
                }, label: {
                    Text(video)
                })
            })
        }, label: {
            Text("Switch Video")
                .bold()
                .foregroundStyle(Color.foreground)
                .padding(5)
        })
    }
}

#Preview {
    VideoSwitcher(videos: ["玩具总动员", "虫虫危机", "玩具总动员2", "怪兽电力公司", "海底总动员", "超人总动员"])
}
