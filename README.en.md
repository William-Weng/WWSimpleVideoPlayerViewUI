[English](./README.en.md) | [繁體中文](./README.md)

# WWSimpleVideoPlayerViewUI

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWSimpleVideoPlayerViewUI)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

A lightweight video player view built on top of Apple's `AVPlayerViewController` and `AVPlayer`.

https://github.com/user-attachments/assets/7b24b0b0-4f5b-4532-8d0e-7bb9627121f7

## 🎬 Introduction

- Uses UIKit's `AVPlayerViewController` to display the built-in system playback controls.
- Under the hood, it uses `AVPlayer` to play local or remote media.
- Accepts `Binding<URL>` and `Binding<Bool>` for the video source and autoplay behavior.
- Supports changing the video source during playback, e.g., switching between different `.mp4` or HLS URLs.

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

- Integrates a `UIKit-based` player into `SwiftUI` for fully customized playback controls.
- Supports play, pause, scrubber seeking, and gesture-based volume and brightness adjustment.
- Allows dynamic video source switching via `Binding<WWSimpleVideoPlayerDataSource>`.
- Supports autoplay control via `Binding<Bool>`.
- Works with both local files and remote video sources.

## 🧩 Available Parameters

| Parameter | Description |
|---|---|
| `source` | A `Binding` to the video source URL. |
| `isAutoplay` | A `Binding` indicating whether to enable automatic playback. |
| `configure` | Configuration settings for the progress bar’s `style`, `color`, `thumbnail` `capture interval`, and `thumbnail size`. |

## 🚀 Examples

### Basic Playback

```swift
import SwiftUI
import WWSimpleVideoPlayerViewUI

struct ContentView: View {
    
    private let configure: WWSimpleVideoPlayerConfigure = .init(thumb: Image("thumb"), mainColor: .mint, thumbnailStep: 10.0, thumbnailSize: .init(width: 240, height: 136))

    @State var isAutoplay = true
    @State var source: ShortVideo = .init(url: .init(string: "https://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4")!)
    
    var body: some View {
        WWSimpleVideoPlayerViewUI<ShortVideo>(source: $source, isAutoplay: $isAutoplay, configure: configure)
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
```

