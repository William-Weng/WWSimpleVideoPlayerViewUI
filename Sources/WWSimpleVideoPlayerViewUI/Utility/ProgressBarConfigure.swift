//
//  WWSimpleVideoPlayerConfigure.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/15.
//

import Foundation
import SwiftUI

/// 進度條的樣式與顏色配置設定
///
/// 此結構用於自訂播放器或進度條的外觀元件，包含拖曳按鈕（Thumb）的圖示以及各個進度狀態的顏色。
public struct WWSimpleVideoPlayerConfigure {
    
    let thumb: Image
    let mainColor: Color
    
    /// 初始化
    /// - Parameters:
    ///   - thumb: 進度條上的拖曳按鈕圖示（例如：圓點、自訂圖示）
    ///   - mainColor: 已播放進度條的顏色（代表目前播放進度走過的區域）
    public init(thumb: Image, mainColor: Color) {
        self.thumb = thumb
        self.mainColor = mainColor
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
            mainColor: .white
        )
    }
}
