//
//  Model.swift
//  WWSimpleVideoPlayerViewUI
//
//  Created by William.Weng on 2026/7/15.
//

import UIKit

/// 影片縮圖項目
struct ThumbnailItem: Identifiable {
    
    let id = UUID()
    let time: TimeInterval  // 時間 (秒)
    let image: UIImage      // 縮圖
}
