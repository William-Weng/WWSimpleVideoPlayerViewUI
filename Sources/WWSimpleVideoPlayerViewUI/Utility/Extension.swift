//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import AVKit

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
    
    static func build(asset: AVAsset, maximumSize: CGSize, requestedTime: CMTime = .positiveInfinity) -> Self {
        
        let generator = Self(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = maximumSize
        generator.requestedTimeToleranceBefore = requestedTime
        generator.requestedTimeToleranceAfter = requestedTime
        
        return generator
    }
}
