//
//  HomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import SwiftUI

struct HomeView: View {
    /// 流媒体视频源.
    let streaming: Streaming
    
    var body: some View {
        VideoPlayer(url: streaming.url)
    }
}

#Preview {
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    return HomeView(streaming: streaming)
}
