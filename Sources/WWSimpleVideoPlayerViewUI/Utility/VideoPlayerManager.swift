//
//  VideoPlayerManager.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import AVKit

@Observable
class VideoPlayerManager {
    
    let player: AVPlayer        // 核心播放物件：AVPlayer
        
    init() {
        player = AVPlayer()
    }
}

// MARK: - 公開API
extension VideoPlayerManager {
    
    /// 開始播放影片
    func play() { player.play() }
    
    /// 暫停影片播放
    func pause() { player.pause() }
    
    /// 停止影片：暫停 + 回到開頭
    func stop() {
        player.pause()
        player.seek(to: .zero)
    }
    
    /// 將影片播放位置跳到指定的秒數
    ///
    /// - Parameter seconds: 要跳到的時間點（秒）
    func loadVideo(url: URL) {
        player.replaceCurrentItem(url: url)
    }
}
