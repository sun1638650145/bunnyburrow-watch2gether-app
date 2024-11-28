//
//  ChatInputTextField.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/11/28.
//

import SwiftUI

struct ChatInputTextField: View {
    @Binding var text: String
    
    /// 输入文本值提交时调用的闭包.
    private var onTextSubmit: (() -> Void)?
    
    init(text: Binding<String>, onTextSubmit: (() -> Void)? = nil) {
        self._text = text
        self.onTextSubmit = onTextSubmit
    }
    
    var body: some View {
        TextField("", text: $text)
            .frame(height: 35)
            .padding(.leading, 5)
            .background(Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255, opacity: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(Color(hex: "#E5E7EB"))
            .onSubmit({
                onTextSubmit?()
            })
            #if os(iOS)
            /// 在iOS上设置提交按钮的标签为发送.
            .submitLabel(.send)
            #elseif os(macOS)
            .textFieldStyle(PlainTextFieldStyle())
            #endif
    }
}

#Preview {
    @Previewable @State var message = ""
    
    ChatInputTextField(text: $message)
}
