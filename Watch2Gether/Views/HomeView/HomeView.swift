//
//  HomeView.swift
//  Watch2Gether
//
//  Created by Steve R. Sun on 2024/8/22.
//

import SwiftUI

struct HomeView: View {
    let url = URL(string: "http://127.0.0.1:8000/video/flower/")
    
    var body: some View {
        VideoPlayer(url: url!)
    }
}

#Preview {
    HomeView()
}
