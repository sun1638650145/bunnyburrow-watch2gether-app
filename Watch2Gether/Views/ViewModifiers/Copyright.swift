//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  Copyright.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/8.
//

import SwiftUI

/// `Copyright`是版权信息文本的样式.
struct Copyright: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(Color.foreground)
    }
}

#Preview {
    Text("Copyright © 2025 Steve R. Sun")
        .modifier(Copyright())
}
