//
//  WWSimpleVideoPlayerConfigure.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/15.
//

import Foundation
import SwiftUI

/// 影片播放器的自訂設定 (用來集中管理進度條樣式與縮圖擷取參數)
public struct WWSimpleVideoPlayerConfigure {
    
    let thumb: Image
    let mainColor: Color
    let thumbnailStep: TimeInterval
    let thumbnailSize: CGSize
    
    /// 初始化
    /// - Parameters:
    ///   - thumb: 進度條上的拖曳按鈕圖示（例如：圓點、自訂圖示）
    ///   - mainColor: 已播放進度條的顏色（代表目前播放進度走過的區域）
    ///   - thumbnailStep: 縮圖擷取步進秒數 (例如：5.0 代表 0~5 抓 0 秒、5~10 抓 5 秒)
    ///   - thumbnailSize: 縮圖預期輸出尺寸 (用來限制 AVAssetImageGenerator 的 maximumSize)
    public init(thumb: Image, mainColor: Color, thumbnailStep: TimeInterval, thumbnailSize: CGSize) {
        self.thumb = thumb
        self.mainColor = mainColor
        self.thumbnailStep = thumbnailStep
        self.thumbnailSize = thumbnailSize
    }
}

// MARK: - 公開屬性
extension WWSimpleVideoPlayerConfigure {
    
    /// 提供內建的預設進度條配置樣式
    ///
    /// 預設樣式包含：
    /// - `thumb`: 系統內建的圓點圖示 (`circle.fill`)
    /// - `fullColor`: 25% 不透明度的白色
    /// - `bufferColor`: 45% 不透明度的白色
    /// - `playedColor`: 全純白
    public static var `default`: Self {
        .init(
            thumb: .init(systemName: "circle.fill"),
            mainColor: .white,
            thumbnailStep: 5.0,
            thumbnailSize: .init(width: 240, height: 136)
        )
    }
}
