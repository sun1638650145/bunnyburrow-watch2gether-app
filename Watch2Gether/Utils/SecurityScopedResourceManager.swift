//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  SecurityScopedResourceManager.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2026/1/8.
//

import Foundation

/// 安全域资源管理器, 通过`bookmarkData`持久化与解析安全域资源的访问权限.
class SecurityScopedResourceManager {
    /// 用于保存`bookmarkData`的`UserDefaults`键.
    private let bookmarkDataKey: String = "Local.bookmarkData"

    /// 当前正在访问的安全域URL.
    private var accessingURL: URL?

    deinit {
        stopAccessing()
    }

    /// 保存URL的`bookmarkData`.
    ///
    /// - Parameters:
    ///   - url: 视频源URL.
    func saveBookmarkData(for url: URL) {
        do {
            let bookmarkData = try url.bookmarkData()

            UserDefaults.standard.set(bookmarkData, forKey: bookmarkDataKey)
        } catch {
            print("获取bookmarkData失败: \(error.localizedDescription)")
        }
    }

    /// 为当前的URL开启安全域访问权限.
    ///
    /// - Parameters:
    ///   - url: 视频源URL.
    /// - Returns: 解析后的URL.
    func startAccessing(for url: URL) -> URL {
        let url = resolveURLfromBookmarkData(url)

        /// 撤销旧的访问权限.
        stopAccessing()

        let accessing = url.startAccessingSecurityScopedResource()
        if accessing {
            accessingURL = url
        }

        return url
    }

    /// 从持久化的`bookmarkData`中解析并恢复安全域URL.
    ///
    /// - Parameters:
    ///   - url: 视频源URL.
    /// - Returns: 若存在有效的`bookmarkData`, 则返回解析后的URL, 否则返回原始URL.
    private func resolveURLfromBookmarkData(_ url: URL) -> URL {
        guard url.isFileURL, let bookmarkData = UserDefaults.standard.data(forKey: bookmarkDataKey)
        else {
            return url
        }

        var isStale: Bool = false

        do {
            let resolvedURL = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)

            /// 如果`bookmarkData`过期则重新保存.
            if isStale {
                saveBookmarkData(for: resolvedURL)
            }

            return resolvedURL
        } catch {
            return url
        }
    }

    /// 撤销当前URL的安全域访问权限.
    private func stopAccessing() {
        if let url = accessingURL {
            url.stopAccessingSecurityScopedResource()
            accessingURL = nil
        }
    }
}
