//
//  AVPlayerView.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/14.
//

import SwiftUI
import AVKit

/// SwiftUI 包裝 AVPlayerViewController 用來在 SwiftUI 中顯示 AVPlayer 內容
struct AVPlayerView: UIViewControllerRepresentable {
    
    let player: AVPlayer        // 外部傳入的播放器實例 => 由外層 manager 負責建立、更新與控制
    let showsControls: Bool     // 是否顯示系統原生播放控制列
    
    /// 建立並回傳 UIKit 的 AVPlayerViewController => SwiftUI 第一次載入時會呼叫這裡
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        let viewController = AVPlayerViewController()
        viewController.player = player
        viewController.showsPlaybackControls = showsControls
        
        return viewController
    }
    
    /// SwiftUI 狀態更新時會呼叫這裡 => 當 player 或控制列設定變動時，更新對應屬性
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
        uiViewController.showsPlaybackControls = showsControls
    }
}
