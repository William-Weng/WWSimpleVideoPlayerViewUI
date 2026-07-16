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
    case progress       // 進度模式（顯示影片目前進度時間 + 總時長）
}

/// 拖動方向（水平快轉 / 垂直操作 / 未知）
enum DragDirection {
    case unknown        // 尚未決定拖動方向（手指剛按下或距離太小）
    case vertical       // 垂直拖動（調整亮度或音量）
    case horizontal     // 水平拖動（調整影片時間）
}

/// 拖動區域（左 / 右 / 中間）
enum DragZone {
    case left           // 左區（通常用於調整亮度）
    case right          // 右區（通常用於調整音量）
    case center         // 中間區域（通常用於普通 seeking 或其他操作）
}

/// 依照 0...1 的數值大小區分的通用等級
///
/// 可用於音量、亮度、進度等需要分段顯示圖示的場景
enum Level {
    
    case empty
    case low
    case medium
    case high
    
    /// 根據 0...1 的數值初始化對應的等級
    ///
    /// - Parameter value: 介於 0...1 的數值，超出範圍時會自動限制在有效區間內
    init(_ value: Double) {
        
        let percentage = Int(value.clamped(to: 0.0...1.0) * 100)
        
        switch percentage {
        case 0: self = .empty
        case 1..<33: self = .low
        case 33..<66: self = .medium
        default: self = .high
        }
    }
}

// MARK: - Level
extension Level {
    
    /// 對應音量狀態的系統圖示名稱
    var volumeIconName: String {
        switch self {
        case .empty: return "speaker.slash.fill"
        case .low: return "speaker.wave.1.fill"
        case .medium: return "speaker.wave.2.fill"
        case .high: return "speaker.wave.3.fill"
        }
    }
    
    /// 對應亮度狀態的系統圖示名稱
    var brightnessIconName: String {
        switch self {
        case .empty: return "moon"
        case .low: return "sun.horizon"
        case .medium: return "sun.min.fill"
        case .high: return "sun.max.fill"
        }
    }
}
