//
//  ImagePickerViewController.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/7.
//

#if os(iOS)
import PhotosUI
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI
import UniformTypeIdentifiers

/// `ImagePickerViewController`是一个通用视图控制器, 允许用户在iOS和macOS上上传图片;
/// 在iOS上使用`PHPickerViewController`并委托`Coordinator`处理; 在macOS上使用`NSOpenPanel`.
#if os(iOS)
struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        
        /// 允许用户选择`照片App`中全部类型的图片.
        configuration.filter = .images
        
        /// 限制选择一张图片.
        configuration.selectionLimit = 1
        
        let viewController = PHPickerViewController(configuration: configuration)
        
        /// 委托`Coordinator`处理.
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // ...
    }
    
    /// 用于处理上传图片后操作的协调器.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerViewController
        
        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            /// 获取上传图片的`itemProvider`.
            guard let provider = results.first?.itemProvider
            else {
                /// 不选择图片也能正常关闭弹出窗口.
                return picker.dismiss(animated: true)
            }
            
            provider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                /// 使用主线程执行, 提高稳定性.
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            })
            
            /// 关闭弹出窗口.
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
#elseif os(macOS)
struct ImagePickerViewController: NSViewControllerRepresentable {
    @Binding var selectedImage: NSImage?
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
#endif

#Preview {
    @Previewable @State var avatar: PlatformImage?
    
    return ImagePickerViewController(selectedImage: $avatar)
}
