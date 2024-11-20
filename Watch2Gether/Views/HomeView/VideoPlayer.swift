//
//  VideoPlayer.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import Foundation
import SwiftUI

struct VideoPlayer: View {
    /// 视频源URL.
    var url: URL
    
    var body: some View {
        ZStack {
            /// 忽略顶部安全区使得视频播放器有更好的一体性.
            Color.black
                .ignoresSafeArea(edges: .top)
            
            VideoPlayerViewController(url: url)
        }
    }
}


#Preview {
    VideoPlayer(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
}
