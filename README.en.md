[English](./README.en.md) | [繁體中文](./README.md)

# 🎬 WWSimpleVideoPlayerViewUI

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWSimpleVideoPlayerViewUI)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

A lightweight video player view built on top of Apple's `VideoPlayer` and `AVPlayer`.

https://github.com/user-attachments/assets/76af5bec-385c-482f-9437-22f6fb6d2826

## 🧩 Introduction

- Uses SwiftUI's `VideoPlayer` to display the built-in system playback controls. [web:26]
- Under the hood, it uses `AVPlayer` to play local or remote media. [web:27]
- Accepts `Binding<URL>` and `Binding<Bool>` for the video source and autoplay behavior. [web:26]
- Supports changing the video source during playback, e.g., switching between different `.mp4` or HLS URLs. [web:27]

```swift
import SwiftUI
import WWSimpleVideoPlayerViewUI

struct ContentView: View {
    @State var isAutoplay = true
    @State var url = URL(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!

    var body: some View {
        WWSimpleVideoPlayerViewUI(url: $url, isAutoplay: $isAutoplay)
    }
}

#Preview {
    ContentView()
}
```


## 📦 Installation

### Swift Package Manager

```bash
swift package add https://github.com/William-Weng/WWSimpleVideoPlayerViewUI.git
```

Or in Xcode:

```
File → Add Packages → https://github.com/William-Weng/WWSimpleVideoPlayerViewUI.git
```

## ✨ Features

- Built with the native `VideoPlayer`, which provides play, pause, volume, progress bar, and fullscreen controls out of the box.
- Video source can be changed dynamically via an external `Binding<URL>`.
- Autoplay behavior can be controlled via a `Binding<Bool>`.
- Supports both local resources and remote video playback.

### Parameters

- `url`: `Binding` to the video source URL.
- `isAutoplay`: `Binding` to control whether playback starts automatically.

## 🚀 Examples

### Basic Playback

```swift
import SwiftUI
import WWSimpleVideoPlayerViewUI

struct ContentView: View {
    @State var isAutoplay = true
    @State var url = URL(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!

    var body: some View {
        WWSimpleVideoPlayerViewUI(url: $url, isAutoplay: $isAutoplay)
    }
}
```

### Switching Video

```swift
import SwiftUI
import WWSimpleVideoPlayerViewUI

struct ContentView: View {
    @State var isAutoplay = true
    @State var url = URL(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!

    var body: some View {
        VStack {
            WWSimpleVideoPlayerViewUI(url: $url, isAutoplay: $isAutoplay)
                .frame(maxWidth: 400)
                .aspectRatio(16 / 9, contentMode: .fit)

            Button("Load another video") {
                url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
            }
        }
    }
}
```
