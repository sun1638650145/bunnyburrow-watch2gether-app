//
//  Copyright © 2024-2026 Steve R. Sun. All rights reserved.
//
//  PlayerViewModelTests.swift
//  Watch2GetherTests
//
//  Created by Steve R. Sun on 2026/3/3.
//

import Foundation
import Testing
@testable import Watch2Gether

struct PlayerViewModelTests {
    @Test
    func autoHidePlaybackControls() {
        let playerViewModel = PlayerViewModel()

        playerViewModel.showPlaybackControls = true
        playerViewModel.resetHidePlaybackControlsTimer(seconds: 0.1)

        RunLoop.current.run(until: Date(timeInterval: 0.2, since: Date()))

        #expect(playerViewModel.showPlaybackControls == false)
    }

    @Test
    func autoHideVolumeDisplay() {
        let playerViewModel = PlayerViewModel()

        playerViewModel.showVolumeDisplay = true
        playerViewModel.resetHideVolumeDisplayTimer(seconds: 0.1)

        RunLoop.current.run(until: Date(timeInterval: 0.2, since: Date()))

        #expect(playerViewModel.showVolumeDisplay == false)
    }

    @Test
    func switchToNewVideo() {
        let url = URL(string: "https://example.com")
        let playerViewModel = PlayerViewModel(url: url!)

        playerViewModel.switchTo(named: "flower")

        #expect(playerViewModel.currentVideoName == "flower")
    }
}
