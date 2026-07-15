//
//  VideoProgressBar.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/14.
//

import SwiftUI
import AVFoundation

// 自定義影片播放進度條
struct VideoProgressBar: View {
    
    let asset: AVAsset
    let currentTime: TimeInterval
    let duration: TimeInterval
    let bufferedTime: TimeInterval
    let configure: WWSimpleVideoPlayerConfigure
    
    private let thumbSize: CGFloat = 14                             // 進度條移動點的大小
    
    private var onChangedAction: ((TimeInterval) -> Void)? = nil    // 拖曳時回傳目標秒數
    private var onEndedAction: ((TimeInterval) -> Void)? = nil      // 拖曳結束後回傳目標秒數
    
    @State private var isDragging = false                           // 記錄是否正在拖動
    @State private var dragValue: Double = 0                        // 拖動時的數值
    @State private var thumbnailProvider = VideoThumbnailProvider()
    
    var body: some View {
        
        VStack(spacing: 6) {
            
            if isDragging, let image = thumbnailProvider.previewImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            HStack(spacing: 8) {
                
                timeTextView(displayTime)
                    .frame(width: 36, alignment: .leading)
                
                GeometryReader { geometry in
                    
                    let width = geometry.size.width
                    
                    progressView(width: width)
                        .contentShape(Rectangle())
                        .gesture(progressDragGesture(width: width))
                }
                .frame(height: thumbSize)
                
                timeTextView(duration)
                    .frame(width: 36, alignment: .trailing)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.black.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: thumbSize))
        .task(id: duration) {
            await thumbnailProvider.prepare(asset: asset, size: configure.thumbnailSize)
        }
    }
    
    /// 初始化播放進度條
    /// - Parameters:
    ///   - url: 影片URL地址
    ///   - currentTime: 目前播放時間（秒）
    ///   - duration: 影片總長度（秒）
    ///   - bufferedTime: 已緩衝到的時間（秒）
    ///   - configure: 進度條相關設定
    init(url: URL, currentTime: TimeInterval, duration: TimeInterval, bufferedTime: TimeInterval, configure: WWSimpleVideoPlayerConfigure) {
        
        self.asset = .init(url: url)
        self.currentTime = currentTime
        self.duration = duration
        self.bufferedTime = bufferedTime
        self.configure = configure
    }
}

// MARK: - SwiftUI 風格的 Modify 擴充 (Extensions)
extension VideoProgressBar {
    
    /// 監聽進度條拖曳中的狀態變更
    func onChanged(_ action: @escaping (TimeInterval) -> Void) -> Self {
        var copy = self
        copy.onChangedAction = action
        return copy
    }
    
    /// 監聽進度條拖曳結束的事件
    func onEnded(_ action: @escaping (TimeInterval) -> Void) -> Self {
        var copy = self
        copy.onEndedAction = action
        return copy
    }
}

// MARK: - 子視圖
private extension VideoProgressBar {
    
    /// 顯示時間文字
    /// - Parameter time: 秒數
    /// - Returns: 格式化後的文字 view
    func timeTextView(_ time: TimeInterval) -> some View {
        
        Text(time.formatTime())
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.7))
    }
    
    /// 畫出進度條
    /// - Parameter width: 進度條可用寬度
    /// - Returns: 播放 / 緩衝 / 拖曳用的視覺元件
    @ViewBuilder
    func progressView(width: CGFloat) -> some View {
        
        let playedWidth = width * progress
        let bufferWidth = width * bufferProgress
        let thumbX = max(0, min(playedWidth - thumbSize * 0.5, width - thumbSize))
        let previewWidth: CGFloat = 120
        let previewHeight: CGFloat = 68
        let previewX = max(0, min(playedWidth - previewWidth * 0.5, width - previewWidth))
        
        ZStack(alignment: .leading) {
                        
            Capsule()
                .fill(Color.white.opacity(0.25))
                .frame(height: 4)
            
            Capsule()
                .fill(Color.white.opacity(0.45))
                .frame(width: bufferWidth, height: 4)
            
            Capsule()
                .fill(configure.mainColor)
                .frame(width: playedWidth, height: 4)
            
            configure.thumb
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: thumbSize, height: thumbSize)
                .offset(x: thumbX)
        }
    }
}

// MARK: - 私有屬性
private extension VideoProgressBar {
    
    /// 目前播放比例
    var progress: TimeInterval {
        guard duration > 0 else { return 0 }
        return min(max((isDragging ? dragValue : currentTime) / duration, 0), 1)
    }

    /// buffer 比例
    var bufferProgress: TimeInterval {
        guard duration > 0 else { return 0 }
        return min(max(bufferedTime / duration, 0), 1)
    }
    
    /// 顯示中的時間 (拖曳中顯示 dragValue / 非拖曳中顯示 currentTime)
    var displayTime: TimeInterval {
        isDragging ? dragValue : currentTime
    }
}

// MARK: - 拖曳手勢
private extension VideoProgressBar {
        
    /// 進度條拖曳手勢
    /// - Parameter width: 進度條寬度
    /// - Returns: DragGesture
    func progressDragGesture(width: CGFloat) -> some Gesture {
        
        DragGesture(minimumDistance: 0)
            .onChanged { progressDragGestureOnChanged(width: width, value: $0) }
            .onEnded { progressDragGestureOnEnded(width: width, value: $0) }
    }
    
    /// 拖曳中更新顯示時間
    /// - Parameters:
    ///   - width: 進度條寬度
    ///   - value: 手勢資訊
    func progressDragGestureOnChanged(width: CGFloat, value: DragGesture.Value) {
        
        let point = min(max(value.location.x / max(width, 1), 0), 1)
        let target = duration * point
        
        isDragging = true
        dragValue = target
        onChangedAction?(target)
        
        thumbnailProvider.updatePreviewIfNeeded(for: target, step: configure.thumbnailStep)
    }
    
    /// 拖曳結束後執行 seek
    /// - Parameters:
    ///   - width: 進度條寬度
    ///   - value: 手勢資訊
    func progressDragGestureOnEnded(width: CGFloat, value: DragGesture.Value) {
        
        let point = min(max(value.location.x / max(width, 1), 0), 1)
        let target = duration * point
        
        dragValue = target
        isDragging = false
        thumbnailProvider.clear()
        onEndedAction?(target)
    }
}
