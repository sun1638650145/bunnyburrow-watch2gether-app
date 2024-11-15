//
//  Streaming.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/23.
//

import Foundation
import Observation

/// 流媒体视频源.
@Observable
class Streaming {
    /// 视频源URL.
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
}
