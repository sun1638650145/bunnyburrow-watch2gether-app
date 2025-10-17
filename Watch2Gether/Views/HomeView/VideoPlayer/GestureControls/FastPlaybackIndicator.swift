//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  FastPlaybackIndicator.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/6/10.
//

import SwiftUI

/// `FastPlaybackIndicator`是倍速播放状态指示视图.
struct FastPlaybackIndicator: View {
    var body: some View {
        VStack {
            HStack {
                FastPlaybackIcon(duration: 0.5)

                Text("Fast playback")
            }
            .padding(12)
            .font(.callout)
            .foregroundStyle(Color.foreground)
            .glassEffectCompat()

            Spacer()
        }
    }
}

#Preview {
    FastPlaybackIndicator()
}
