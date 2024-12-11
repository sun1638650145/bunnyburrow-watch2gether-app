//
//  VideoPlayerCommands.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/12/11.
//

import SwiftUI

struct VideoPlayerCommands: Commands {
    @Binding var streamingViewModel: StreamingViewModel

    var body: some Commands {
        CommandMenu("播放器", content: {
            Button(action: {
                streamingViewModel.isFullScreen.toggle()
            }, label: {
                Text(streamingViewModel.isFullScreen ? "退出全屏幕" : "进入全屏幕")
            })
            .keyboardShortcut(.escape, modifiers: .command)
            
            Divider()
            
            Button(action: {
                // ...
            }, label: {
                Text("恭喜您发现彩蛋🎉")
            })
        })
    }
}
