//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  FriendsViewModelTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/2/13.
//

import Testing
@testable import Watch2Gether

struct FriendsViewModelTests {
    @Test
    func addSameFriendTwice() {
        let friendsViewModel = FriendsViewModel()
        let user = User(clientID: 2026, name: "Steve")

        friendsViewModel.addFriend(friend: user)
        friendsViewModel.offlineFriend(by: user.clientID)
        friendsViewModel.addFriend(friend: user)

        let onlineFriends = friendsViewModel.getOnlineFriendsList()

        #expect(onlineFriends.count == 1)
    }
}
