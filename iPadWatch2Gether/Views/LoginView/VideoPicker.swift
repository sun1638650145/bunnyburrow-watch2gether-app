//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPicker.swift
//  iPadWatch2Gether
//
//  Created by Steve R. Sun on 2025/3/18.
//

import SwiftUI

/// `VideoPicker`是用于视频选择的视图, 允许用户选择一个本地视频文件.
struct VideoPicker: View {
    @Binding var url: String?

    /// 是否呈现`VideoPickerViewController`.
    @State private var isPresented: Bool = false

    init(_ url: Binding<String?>) {
        self._url = url
    }

    var body: some View {
        Button(action: {
            isPresented = true
        }, label: {
            Image(systemName: "document.badge.plus.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.foreground)
        })
        .sheet(isPresented: $isPresented, content: {
            VideoPickerViewController(selectedVideo: $url)
        })
    }
}

#Preview {
    @Previewable @State var url: String?

    VideoPicker($url)
}
