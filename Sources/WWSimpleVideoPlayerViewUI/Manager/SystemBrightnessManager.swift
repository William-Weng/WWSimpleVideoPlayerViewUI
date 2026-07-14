//
//  SystemBrightnessManager.swift
//  Example
//
//  Created by William.Weng on 2026/7/13.
//

import Foundation
import UIKit

// MARK: - 輔助元件：修改 / 監聽系統亮度工具
final class SystemBrightnessManager {
    
    static let shared = SystemBrightnessManager()
        
    private init() {}
    
    /// 目前螢幕亮度
    var currentBrightness: CGFloat {
        UIScreen.main.brightness
    }
    
    /// 設置螢幕亮度
    func setBrightness(_ value: CGFloat) {
        let clampedValue = min(max(value, 0), 1)
        
        Task { @MainActor in
            UIScreen.main.brightness = clampedValue
        }
    }
}
