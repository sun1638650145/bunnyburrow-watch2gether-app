//
//  StyledPlaceholderTextField.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/13.
//

import SwiftUI

struct StyledPlaceholderTextField: View {
    @Binding var text: String?
    
    /// 是否处于无效状态.
    private let isInvalid: Bool
    
    /// 占位符文本.
    private let placeholder: String
    
    /// 占位符文本的颜色.
    private let placeholderColor: Color
    
    init(_ placeholder: String, text: Binding<String?>, placeholderColor: Color = .secondary, isInvalid: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.placeholderColor = placeholderColor
        self.isInvalid = isInvalid
    }
    
    var body: some View {
        ZStack(alignment: .leading, content: {
            if (text ?? "").isEmpty {
                Text(placeholder)
                    .foregroundStyle(placeholderColor)
                    .padding(.leading, 5)
            }
            TextField("", text: Binding<String>(
                get: { text ?? "" },
                set: { newValue in
                    text = newValue.isEmpty ? nil : newValue
                }
            ))
            .foregroundStyle(Color(hex: "#F9F9F9"))
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.leading, 5)
        })
        .font(.title3)
        .frame(width: 350, height: 50)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(isInvalid ? Color(hex: "#FF554C") : Color.clear, lineWidth: 1))
    }
}

#Preview {
    @State var name: String?
    
    return StyledPlaceholderTextField(
        "请输入昵称",
        text: $name,
        placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255)
    )
    .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.1))
    .clipShape(RoundedRectangle(cornerRadius: 5))
    .padding(10)
}
