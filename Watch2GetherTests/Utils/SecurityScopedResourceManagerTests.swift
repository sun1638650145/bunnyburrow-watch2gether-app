//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  SecurityScopedResourceManagerTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/7/1.
//

import Foundation
import Testing

@testable import Watch2Gether

struct SecurityScopedResourceManagerTests {
    /// 与安全域资源管理器内部用于保存`bookmarkData`的`UserDefaults`键保持一致.
    private let bookmarkDataKey: String = "Local.bookmarkData"

    @Test
    func saveBookmarkData() throws {
        removeBookmarkData()

        let url = try createTemporaryFile()

        SecurityScopedResourceManager.saveBookmarkData(for: url)

        let bookmarkData = UserDefaults.standard.data(forKey: bookmarkDataKey)

        #expect(bookmarkData?.isEmpty == false)
    }

    /// 创建临时文件, 并返回其URL.
    ///
    /// - Returns: 已创建临时文件的URL.
    /// - Throws: 创建临时目录或写入临时文件失败时抛出异常.
    private func createTemporaryFile() throws -> URL {
        let directoryUrl = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString, directoryHint: .isDirectory)

        try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)

        let fileUrl = directoryUrl.appending(path: UUID().uuidString, directoryHint: .notDirectory)

        try Data().write(to: fileUrl)

        return fileUrl
    }

    /// 移除已保存的`bookmarkData`, 避免测试访问到旧数据.
    private func removeBookmarkData() {
        UserDefaults.standard.removeObject(forKey: bookmarkDataKey)
    }
}
