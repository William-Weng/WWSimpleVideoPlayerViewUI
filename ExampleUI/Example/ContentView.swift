//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/7/7.
//

import SwiftUI
import WWSimpleVideoPlayerViewUI

struct ContentView: View {
    
    private let configure: WWSimpleVideoPlayerConfigure = .init(thumb: Image("thumb"), mainColor: .mint, thumbnailStep: 5.0, thumbnailSize: .init(width: 240, height: 136))
    
    @State var isAutoplay = true
    @State var source: ShortVideo = .init(url: .init(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!)

    var body: some View {
        
        WWSimpleVideoPlayerViewUI<ShortVideo>(source: $source, isAutoplay: $isAutoplay, configure: configure)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
