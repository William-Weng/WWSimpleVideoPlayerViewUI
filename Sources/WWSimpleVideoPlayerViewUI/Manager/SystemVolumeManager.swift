//
//  SystemVolumeManager.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import Foundation
import MediaPlayer
import AVFoundation

// MARK: - 輔助元件：修改 / 監聽系統音量工具
final class SystemVolumeManager {
    
    static let shared = SystemVolumeManager()
    
    private let audioSession = AVAudioSession.sharedInstance()
    private let volumeView = MPVolumeView(frame: .zero)
    
    private init() {}
    
    /// 目前系統音量
    var currentVolume: Float {
        audioSession.outputVolume
    }
    
    /// 設置系統音量
    func setVolume(_ value: Float) {
        
        let clampedValue = min(max(value, 0), 1)
        
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            Task { @MainActor in
                slider.value = clampedValue
            }
        }
    }
}
