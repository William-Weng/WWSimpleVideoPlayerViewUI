//
//  Constant.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import Foundation

/// HUD 提示類型（亮度條、音量條、快轉進度等）
enum HUDType {
    case brightness     // 亮度模式（顯示亮度圖示 + 亮度進度條）
    case volume         // 音量模式（顯示音量圖示 + 音量進度條）
}

/// 拖動方向（水平快轉 / 垂直操作 / 未知）
enum DragDirection {
    case unknown        // 尚未決定拖動方向（手指剛按下或距離太小）
    case vertical       // 垂直拖動（調整亮度或音量）
}

/// 拖動區域（左 / 右 / 中間）
enum DragZone {
    case left           // 左區（通常用於調整亮度）
    case right          // 右區（通常用於調整音量）
    case center         // 中間區域（通常用於普通 seeking 或其他操作）
}
