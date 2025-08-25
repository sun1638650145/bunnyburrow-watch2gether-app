//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  URL.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/8/24.
//

import Foundation

extension URL {
    /// 返回域名URL.
    var domainURL: URL? {
        guard let scheme = self.scheme, let host = self.host()
        else {
            return nil
        }

        return URL(string: scheme + "://" + host + (self.port.map({ ":\($0)" }) ?? "") + "/")
    }
}
