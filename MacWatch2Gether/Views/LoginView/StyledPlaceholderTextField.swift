//
//  StyledPlaceholderTextField.swift
//  MacWatch2Gether
//
//  Created by Steve R. Sun on 2024/11/8.
//

import SwiftUI

struct StyledPlaceholderTextField: View {
    @Binding var text: String?
    
    /// 获取焦点位置.
    @FocusState private var isFocused: Bool
    
    /// 计算当前的边框颜色.
    private var borderColor: Color {
        if errorMessage != nil {
            return Color(hex: "#FF554C")
        } else if isFocused {
            return Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.2)
        } else {
            return Color.clear
        }
    }
    
    /// 错误信息文本.
    private var errorMessage: String?
    
    /// 输入文本值更改时调用的闭包.
    private var onTextChange: (() -> Void)?
    
    /// 占位符文本.
    private var placeholder: String
    
    /// 占位符文本的颜色.
    private var placeholderColor: Color
    
    init(
        _ placeholder: String,
        text: Binding<String?>,
        placeholderColor: Color = .secondary,
        errorMessage: String? = nil,
        onTextChange: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.placeholderColor = placeholderColor
        self.errorMessage = errorMessage
        self.onTextChange = onTextChange
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
                    set: { text = $0.isEmpty ? nil : $0 }
                ))
                .focused($isFocused)
                .foregroundStyle(Color(hex: "#F9F9F9"))
                .onChange(of: text, {
                    onTextChange?()
                })
                .padding(.leading, 5)
                .textFieldStyle(PlainTextFieldStyle())
            })
            .frame(width: 350, height: 50)
            .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .font(.title3)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1.2)
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
    @Previewable @State var isNameEmpty = false
    @Previewable @State var name: String?
    @Previewable @State var url: String?
    
    VStack {
        StyledPlaceholderTextField(
            "请输入昵称",
            text: $name,
            placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
            errorMessage: isNameEmpty ? "昵称不能为空, 请输入昵称并重试." : nil,
            onTextChange: {
                isNameEmpty = name?.isEmpty ?? true
            }
        )
        
        StyledPlaceholderTextField(
            "请输入流媒体视频源",
            text: $url,
            placeholderColor: Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255),
            errorMessage: nil
        )
    }
    .padding(20)
}
