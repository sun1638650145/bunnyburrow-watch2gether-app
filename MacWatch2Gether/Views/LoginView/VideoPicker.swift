//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPicker.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2025/3/22.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

/// `VideoPicker`是用于视频选择的视图, 允许用户选择一个本地视频文件.
struct VideoPicker: View {
    @Binding var url: String?
    @Environment(AppSettings.self) var appSettings

    init(_ url: Binding<String?>) {
        self._url = url
    }

    var body: some View {
        Button(action: {
            appSettings.isPanelActive = true
            present()
            appSettings.isPanelActive = false
        }, label: {
            Image(systemName: "document.badge.plus.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.foreground)
        })
        .buttonStyle(PlainButtonStyle())
        .onHover(perform: { hovering in
            /// 在悬停时使用手形光标.
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
    }

    /// 展示`NSOpenPanel`允许用户选择视频.
    private func present() {
        let openPanel = NSOpenPanel()

        /// 目前允许用户选择MPEG-2和MPEG-4格式的视频.
        openPanel.allowedContentTypes = [.mpeg2TransportStream, .mpeg4Movie]

        /// 作为模态窗口展示.
        let response = openPanel.runModal()

        /// 使用主线程执行, 提高稳定性.
        DispatchQueue.main.async {
            if response == .OK {
                if let url = openPanel.url {
                    self.url = url.absoluteString
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var url: String?

    let appSettings = AppSettings()

    VideoPicker($url)
        .environment(appSettings)
}
