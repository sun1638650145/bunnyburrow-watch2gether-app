//
//  Copyright © 2024-2025 Steve R. Sun. All rights reserved.
//
//  MuteIndicator.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2025/3/13.
//

import SwiftUI

/// `MuteIndicator`是静音状态指示视图.
struct MuteIndicator: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "volume.slash.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color.foreground)
                    .frame(width: 20, height: 20)

                RoundedRectangle(cornerRadius: 2)
                    .foregroundStyle(Color.foreground.opacity(0.2))
                    .frame(width: 100, height: 4)
            }
            .padding(10)
            .glassEffectCompat()

            Spacer()
        }
    }
}

#Preview {
    MuteIndicator()
}
