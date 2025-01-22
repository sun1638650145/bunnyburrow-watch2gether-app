//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  ImagePickerViewController.swift
//  Watch2Gether
//
//  Create by Steve R. Sun on 2024/8/7.
//

import PhotosUI
import SwiftUI
import UIKit

/// `ImagePickerViewController`是使用`PHPickerViewController`实现的图片选择视图控制器;
/// 它允许用户从`照片App`中选择一张图片, 并将图片转换成Base-64编码的字符串.
struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var selectedImage: String?

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

            provider.loadObject(ofClass: UIImage.self, completionHandler: { image, _ in
                /// 使用主线程执行, 提高稳定性.
                DispatchQueue.main.async {
                    guard let image = image as? UIImage
                    else {
                        /// 转换失败关闭弹出窗口.
                        return picker.dismiss(animated: true)
                    }

                    /// 调整到350x350像素以内的大小并转换成Base-64编码的字符串.
                    self.parent.selectedImage = image
                        .resize(within: CGSize(width: 350, height: 350))
                        .toBase64()
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
