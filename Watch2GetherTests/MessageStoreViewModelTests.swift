//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  MessageStoreViewModelTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/2/28.
//

import Testing
@testable import Watch2Gether

struct MessageStoreViewModelTests {
    @Test
    func addMessage() {
        let messageStoreViewModel = MessageStoreViewModel()
        let message = Message(content: "你好", clientID: 2025)

        messageStoreViewModel.addMessage(message: message)

        #expect(messageStoreViewModel.messages.count == 1)
        #expect(messageStoreViewModel.messages.first == message)
    }
}
