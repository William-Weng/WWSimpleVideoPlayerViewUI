//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import AVKit

// MARK: - Comparable
extension Comparable {
    
    /// 將目前的值限制在指定的閉區間內。
    ///
    /// - Parameter range: 允許的最小值與最大值範圍。
    /// - Returns: 落在 `range.lowerBound...range.upperBound` 之間的值。
    func clamped(to range: ClosedRange<Self>) -> Self {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - CGFloat
extension CGFloat {
    
    /// 將目前的 x 位置依照可拖曳寬度轉成 0...1 的進度比例。
    ///
    /// - Parameter width: 可拖曳區域的寬度。
    /// - Returns: 介於 0...1 之間的標準化進度值。
    func normalizedProgress(for width: CGFloat) -> CGFloat {
        
        let safeWidth = Swift.max(width, 1.0)
        let progress = self / safeWidth
        
        return progress.clamped(to: 0.0...1.0)
    }
    
    /// 給相對位移用，例如 translation.width / width
    ///
    /// - Parameter width: 可拖曳區域的寬度。
    /// - Returns: 介於 -1...1 之間的標準化進度值。
    func normalizedDelta(for width: CGFloat) -> CGFloat {
        
        let safeWidth = Swift.max(width, 1.0)
        let ratio = self / safeWidth
        
        return ratio.clamped(to: -1.0...1.0)
    }
}

// MARK: - TimeInterval
extension TimeInterval {
    
    /// 將秒數格式化成 mm:ss (例如：65.2 -> 1:05)
    func formatTime() -> String {
        
        guard isFinite else { return "0:00" }
        
        let total = Int(rounded())
        let minutes = total / 60
        let seconds: Int = total % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - AVPlayer
extension AVPlayer {
    
    /// 替換當前播放的影片項目為指定 URL 的資源
    ///
    /// 使用此方法可以快速切換播放內容，無需自己手動創建 `AVAsset` 和 `AVPlayerItem`
    ///
    /// - Parameter url: 影片資源的 URL
    func replaceCurrentItem(url: URL) {
        
        let asset = AVAsset(url: url)
        let newItem = AVPlayerItem(asset: asset)
        
        replaceCurrentItem(with: newItem)
    }
}

// MARK: - AVAssetImageGenerator
extension AVAssetImageGenerator {
    
    /// 建立 AVAssetImageGenerator
    /// - Parameters:
    ///   - asset: 影片的AVAsset
    ///   - maximumSize: 縮圖的最大尺寸
    ///   - toleranceBefore: 允許在指定時間點「之前」偏移的最大時間
    ///   - toleranceAfter: 允許在指定時間點「之後」偏移的最大時間
    /// - Returns: 對應時間點的縮圖
    static func build(asset: AVAsset, maximumSize: CGSize, toleranceBefore: CMTime = .positiveInfinity, toleranceAfter: CMTime = .positiveInfinity) -> Self {
        
        let generator = Self(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = maximumSize
        generator.requestedTimeToleranceBefore = toleranceBefore
        generator.requestedTimeToleranceAfter = toleranceAfter
        
        return generator
    }
}
