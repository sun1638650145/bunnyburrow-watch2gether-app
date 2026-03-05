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

    @Test
    func offlineAllFriends() {
        let friendsViewModel = FriendsViewModel()
        let user = User(clientID: 2026, name: "Steve")
        let friend = User(clientID: 2025, name: "A")

        friendsViewModel.addFriend(friend: user)
        friendsViewModel.addFriend(friend: friend)

        var onlineFriends = friendsViewModel.getOnlineFriendsList()

        #expect(onlineFriends.count == 2)

        friendsViewModel.offlineAllFriends()

        onlineFriends = friendsViewModel.getOnlineFriendsList()

        #expect(onlineFriends.count == 1, "调用函数`offlineAllFriends()`后, 应只剩自己保持在线状态.")
        #expect(onlineFriends[0].clientID == user.clientID)
        #expect(onlineFriends[0].name == user.name)
    }

    @Test
    func searchFriend() {
        let friendsViewModel = FriendsViewModel()
        let user = User(clientID: 2026, name: "Steve")

        friendsViewModel.addFriend(friend: user)

        let friend1 = friendsViewModel.searchFriend(by: user.clientID)
        let friend2 = friendsViewModel.searchFriend(by: 1)

        #expect(friend1?.clientID == user.clientID)
        #expect(friend1?.name == user.name)
        #expect(friend2?.clientID == nil)
    }
}
