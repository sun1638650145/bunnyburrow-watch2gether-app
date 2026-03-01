//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  MockURLProtocol.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/1.
//

import Foundation

import SwiftyJSON

/// 用于测试的`URLProtocol`, 拦截`URLSession`发起的网络请求并返回模拟的数据.
class MockURLProtocol: URLProtocol {
    /// 每次模拟响应的HTTP状态码.
    static let statusCode: Int = 200

    /// 每次模拟返回的JSON数据.
    static var json: JSON?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: self.request.url!,
            statusCode: Self.statusCode,
            httpVersion: nil,
            headerFields: nil
        )

        /// 通知客户端已发送响应头.
        self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)

        /// 如果有JSON数据, 通知客户端已发送响应体.
        if let json = Self.json, let data = try? json.rawData() {
            self.client?.urlProtocol(self, didLoad: data)
        }

        /// 通知客户端本次加载已完成.
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // ...
    }
}
