//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/7/7.
//

import SwiftUI
import WWSimpleVideoPlayerViewUI

struct ContentView: View {
    
    @State var isAutoplay = true
    @State var url = URL(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!
    
    var body: some View {
        WWSimpleVideoPlayerViewUI(url: $url, isAutoplay: $isAutoplay)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
