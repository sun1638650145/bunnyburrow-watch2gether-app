//
//  ImagePickerViewController.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/7.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

/// `ImagePickerViewController`使用`NSOpenPanel`来上传图片文件.
struct ImagePickerViewController: NSViewControllerRepresentable {
    @Binding var selectedImage: PlatformImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeNSViewController(context: Context) -> NSViewController {
        let openPanel = NSOpenPanel()
        let viewController = NSViewController()
        
        /// 只允许用户选择媒体类型为图片的文件.
        openPanel.allowedContentTypes = [UTType.image]
        
        /// 弹出的窗口位于标准窗口之上.
        openPanel.level = .floating
        
        openPanel.begin { response in
            /// 使用主线程执行, 提高稳定性.
            DispatchQueue.main.async {
                if response == .OK {
                    if let url = openPanel.url {
                        self.selectedImage = NSImage(contentsOf: url)
                    }
                }
                
                /// 关闭弹出窗口.
                self.dismiss()
            }
        }
        
        return viewController
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // ...
    }
}

#Preview {
    @State var avatar: PlatformImage?
    
    return ImagePickerViewController(selectedImage: $avatar)
}
