//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import AVKit

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
