//
//  VideoPlayer.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/20.
//

import Foundation
import SwiftUI

struct VideoPlayer: View {
    var body: some View {
        ZStack {
            /// 使得视频播放器有更好的一体性.
            Color.black
            
            VideoPlayerView()
        }
    }
}

#Preview {
    let streaming = Streaming(url: URL(string: "http://127.0.0.1:8000/video/flower/")!)
    
    VideoPlayer()
        .environment(streaming)
}
