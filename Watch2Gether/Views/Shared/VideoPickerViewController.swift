//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  VideoPickerViewController.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/18.
//

import SwiftUI
import UniformTypeIdentifiers

/// `VideoPickerViewController`是使用`UIDocumentPickerViewController`实现的视频选择视图控制器;
/// 它允许用户从`文件App`中选择一个视频文件.
struct VideoPickerViewController: UIViewControllerRepresentable {
    @Binding var selectedVideo: String?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        /// 目前允许用户选择MPEG-4格式的视频.
        let viewController = UIDocumentPickerViewController(forOpeningContentTypes: [.mpeg4Movie])

        /// 禁止用户选择多个文件.
        viewController.allowsMultipleSelection = false

        /// 委托`Coordinator`处理.
        viewController.delegate = context.coordinator

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // ...
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: VideoPickerViewController

        init(_ parent: VideoPickerViewController) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first?.absoluteString
            else {
                return
            }

            self.parent.selectedVideo = url
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
