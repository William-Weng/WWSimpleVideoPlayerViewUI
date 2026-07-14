[English](./README.en.md) | [繁體中文](./README.md)

# 🎬 WWSimpleVideoPlayerViewUI

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWSimpleVideoPlayerViewUI)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

根據 Apple 的 `VideoPlayer` 與 `AVPlayer` 所開發的輕量影片播放器。

https://github.com/user-attachments/assets/76af5bec-385c-482f-9437-22f6fb6d2826

## 🧩 簡介

- 使用 SwiftUI 的 `VideoPlayer`，直接展示系統內建的播放控制器。
- 背後使用 `AVPlayer` 來播放本地或網路影片。
- 使用 `Binding<URL>` 與 `Binding<Bool>` 接收外部影片來源與是否自動播放。
- 支援在播放過程中更換影片來源，例如切換不同的 .mp4 或 HLS 網址。

## 📦 安裝方式

### Swift Package Manager

```bash
swift package add https://github.com/William-Weng/WWSimpleVideoPlayerViewUI.git
```

或在 Xcode 中：

```
File → Add Packages → https://github.com/William-Weng/WWSimpleVideoPlayerViewUI.git
```

## ✨ 功能

- 使用原生 `VideoPlayer`，自帶播放、暫停、音量、進度條與全屏控制。
- 可透過外部 `Binding<WWSimpleVideoPlayerDataSource>` 動態更換影片來源。
- 可透過 `Binding<Bool>` 控制是否自動播放。
- 支援本地資源與遠端影片播放。

### 參數

- `source`: 影片來源 URL 的 `Binding`。
- `isAutoplay`: 是否自動播放的 `Binding`。

## 🚀 範例

### 基本播放

```swift
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
```
