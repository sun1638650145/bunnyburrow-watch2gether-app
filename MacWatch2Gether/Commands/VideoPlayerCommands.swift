//
//  VideoPlayerCommands.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/12/11.
//

import SwiftUI

struct VideoPlayerCommands: Commands {
    @Binding var streamingViewModel: StreamingViewModel
    
    /// 登录状态.
    let isLoggedIn: Bool
    
    /// 用户信息.
    let user: User
    
    /// WebSocket客户端.
    let websocketClient: WebSocketClient
    
    init(
        _ isLoggedIn: Bool,
        _ user: User,
        _ streamingViewModel: Binding<StreamingViewModel>,
        _ websocketClient: WebSocketClient
    ) {
        self.isLoggedIn = isLoggedIn
        self.user = user
        self._streamingViewModel = streamingViewModel
        self.websocketClient = websocketClient
    }

    var body: some Commands {
        CommandMenu("播放器", content: {
            Button(action: {
                if streamingViewModel.isPlaying {
                    streamingViewModel.player.pause()
                    sendPlayerSync(command: "pause")
                } else {
                    streamingViewModel.player.play()
                    sendPlayerSync(command: "play")
                }
            }, label: {
                Text(streamingViewModel.isPlaying ? "暂停" : "播放")
            })
            .disabled(!isLoggedIn)
            .keyboardShortcut(.return, modifiers: .command)
            
            Button(action: {
                streamingViewModel.isFullScreen.toggle()
            }, label: {
                Text(streamingViewModel.isFullScreen ? "退出全屏幕" : "进入全屏幕")
            })
            .disabled(!isLoggedIn)
            .keyboardShortcut(.escape, modifiers: .command)
            
            Divider()
            
            Button(action: {
                // ...
            }, label: {
                Text("恭喜您发现彩蛋🎉")
            })
        })
    }
    
    /// 发送播放器状态同步.
    ///
    /// - Parameters:
    ///   - command: 状态同步命令字段.
    private func sendPlayerSync(command: String) {
        websocketClient.broadcast([
            "action": "player",
            "command": command,
            "user": [
                /// 只发送客户端ID以减小网络开销.
                "clientID": user.clientID
            ]
        ])
    }
}
