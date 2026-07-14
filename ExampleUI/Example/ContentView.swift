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
    @State var source: ShortVideo = .init(url: .init(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!)
    
    var body: some View {
        WWSimpleVideoPlayerViewUI<ShortVideo>(source: $source, isAutoplay: $isAutoplay)
            .frame(maxWidth: .infinity)
    }
}

struct ShortVideo: WWSimpleVideoPlayerDataSource {
    
    let id: UUID = .init()
    var url: URL
}

#Preview {
    ContentView()
}
