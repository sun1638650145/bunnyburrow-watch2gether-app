//
//  Copyright.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/8.
//

import SwiftUI

/// `Copyright`是版权文本的样式.
struct Copyright: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255))
    }
}

#Preview {
    Text("Copyright © 2024 Steve R. Sun")
        .modifier(Copyright())
        .padding(5)
}
