//
//  VideoThumbnailProvider.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/15.
//

import SwiftUI
import AVFoundation

/// 提供影片拖曳時的縮圖預覽
/// - Note:
///   1. 先用 `prepare(asset:size:)` 建立縮圖產生器
///   2. 拖曳時呼叫 `updatePreviewIfNeeded(for:step:)` 更新預覽圖
///   3. 結束時呼叫 `clear()` 清掉目前狀態
@Observable
final class VideoThumbnailProvider {
    
    var previewImage: UIImage?                      // 目前要顯示在 UI 上的預覽圖
    
    @ObservationIgnored
    private var generator: AVAssetImageGenerator?   // AVFoundation 提供的縮圖產生器 (用來從影片指定時間點擷取畫面)
    
    @ObservationIgnored
    private var lastRequestedSecond: TimeInterval?  // 上一次實際送出請求的秒數 (用來避免同一個 bucket 重複擷取)
    
    @ObservationIgnored
    private var requestID = UUID()                  // 每次發新請求就更新一次 (避免舊的非同步 callback 回來時覆蓋新的圖片)
}

// MARK: - 公開API
extension VideoThumbnailProvider {
    
    /// 準備縮圖產生器
    /// - Parameters:
    ///   - asset: 影片資源
    ///   - size: 預計產生的最大縮圖尺寸
    func prepare(asset: AVAsset, size: CGSize) async {
        
        do {
            _ = try await asset.load(.tracks)
            self.generator = .build(asset: asset, maximumSize: size)
        } catch {
            print("prepare thumbnail failed:", error)
        }
    }
    
    /// 依照拖曳秒數更新預覽圖
    ///
    /// 將秒數往下吸附到指定步進
    /// 例如 step = 5 時：
    /// - 0.0 ~ 4.999 -> 0
    /// - 5.0 ~ 9.999 -> 5
    /// - 10.0 ~ 14.999 -> 10
    ///
    /// - Parameters:
    ///   - second: 目前拖曳到的秒數
    ///   - step: 幾秒為一格，預設每 5 秒抓一張
    func updatePreviewIfNeeded(for second: TimeInterval, step: TimeInterval) {
        
        guard let generator else { return }
        let snappedSecond = max(0, floor(second / step) * step)
        
        guard lastRequestedSecond != snappedSecond else { return }
        lastRequestedSecond = snappedSecond
        
        requestID = UUID()
        let currentID = requestID
        
        generator.cancelAllCGImageGeneration()
        
        let time = CMTime(seconds: snappedSecond, preferredTimescale: 600)
        
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { [weak self] _, cgImage, _, _, error in
            
            guard let self else { return }
            guard self.requestID == currentID else { return }
            guard error == nil, let cgImage else { return }
            
            Task { @MainActor in
                self.previewImage = UIImage(cgImage: cgImage)
            }
        }
    }
    
    /// 清除目前的預覽狀態
    func clear() {
        generator?.cancelAllCGImageGeneration()
        previewImage = nil
        lastRequestedSecond = nil
    }
}
