//
//  User.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/5.
//

#if os(macOS)
import AppKit
#endif
import Foundation

/// 用户信息.
struct User: Identifiable {
    /// 头像的Base-64.
    let avatar: String?
    
    /// 客户端ID.
    let clientID: UInt
    
    /// 昵称.
    let name: String
    
    /// 遵循`Identifiable`协议要求.
    var id: UInt {
        return clientID
    }
    
    init(_ avatar: PlatformImage? = nil, _ name: String) {
        self.avatar = User.convertAvatarToBase64(avatar)
        // TODO: 目前使用时间戳生成, 未来改进为使用UUID; 同时兼容Web客户端的实现(Steve).
        self.clientID = UInt(Date().timeIntervalSince1970 * 1000)
        self.name = name
    }
    
    /// 将用户的头像转换成Base-64编码的字符串.
    ///
    /// - Parameter avatar: 用户的头像.
    /// - Returns: 头像的Base-64编码字符串.
    private static func convertAvatarToBase64(_ avatar: PlatformImage?) -> String? {
        /// 在iOS上, 使用`pngData()`将图片转换成数据.
        #if os(iOS)
        guard let image = avatar,
              let data = image.pngData()
        else {
            return nil
        }
        
        /// 在macOS上, 先将图片转换成tiff格式, 再转换为bitmap格式, 最后转换成数据.
        #elseif os(macOS)
        guard let image = avatar,
              let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let data = bitmap.representation(using: .png, properties: [:])
        else {
            return nil
        }
        #endif
        
        return "data:image/png;base64,\(data.base64EncodedString())"
    }
}
