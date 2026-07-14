//
//  VideoProgressBar.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/14.
//

import SwiftUI

struct VideoProgressBar: View {
    
    let currentTime: TimeInterval       // 目前播放時間（秒）
    let duration: TimeInterval          // 影片總長度（秒）
    let bufferedTime: TimeInterval      // 已緩衝到的時間（秒）
    
    let onSeek: (TimeInterval) -> Void  // 拖曳結束後回傳目標秒數
    let thumb: Image
    
    private let thumbSize: CGFloat = 14

    @State private var isDragging = false
    @State private var dragValue: Double = 0
    
    var body: some View {
        
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
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.black.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: thumbSize))
    }
    
    init(currentTime: TimeInterval, duration: TimeInterval, bufferedTime: TimeInterval, thumb: Image = Image(systemName: "circle.fill"), onSeek: @escaping (TimeInterval) -> Void) {
        
        self.currentTime = currentTime
        self.duration = duration
        self.bufferedTime = bufferedTime
        self.thumb = thumb
        self.onSeek = onSeek
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
        let thumbX = max(0, playedWidth - thumbSize / 2)
        
        ZStack(alignment: .leading) {
            
            Capsule()
                .fill(.white.opacity(0.25))
                .frame(height: 4)
            
            Capsule()
                .fill(.white.opacity(0.45))
                .frame(width: bufferWidth, height: 4)

            Capsule()
                .fill(.white)
                .frame(width: playedWidth, height: 4)
            
            thumb
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
        
        isDragging = true
        dragValue = duration * point
    }
    
    /// 拖曳結束後執行 seek
    /// - Parameters:
    ///   - width: 進度條寬度
    ///   - value: 手勢資訊
    func progressDragGestureOnEnded(width: CGFloat, value: DragGesture.Value) {
        
        let point = min(max(value.location.x / max(width, 1), 0), 1)
        let target = duration * point
        
        isDragging = false
        dragValue = target
        onSeek(target)
    }
}
