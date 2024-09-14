//
//  StyledPlaceholderTextField.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/13.
//

import SwiftUI

struct StyledPlaceholderTextField: View {
    @Binding var text: String?
    
    /// 错误信息文本.
    private let errorMessage: String?
    
    /// 占位符文本.
    private let placeholder: String
    
    /// 占位符文本的颜色.
    private let placeholderColor: Color
    
    init(
        _ placeholder: String,
        text: Binding<String?>,
        placeholderColor: Color = .secondary,
        errorMessage: String? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.placeholderColor = placeholderColor
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack {
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
            .frame(width: 350, height: 50)
            .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title3)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        errorMessage != nil
                            ? Color(hex: "#FF554C")
                            : Color.clear,
                        lineWidth: 1.2
                    )
            })
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundStyle(Color(hex: "#FF554C"))
                    .padding(.top, 3)
            }
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
    }
}

#Preview {
    @State var name: String?
    @State var url: String?
    
    return Group {
        StyledPlaceholderTextField(
            "请输入昵称",
            text: $name,
            placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
            errorMessage: "昵称不能为空, 请输入昵称并重试."
        )
        
        StyledPlaceholderTextField(
            "请输入流媒体视频源",
            text: $url,
            placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
            errorMessage: nil
        )
    }
}
