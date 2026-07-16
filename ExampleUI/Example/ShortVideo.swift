//
//  ShortVideo.swift
//  Example
//
//  Created by William.Weng on 2026/7/16.
//

import SwiftUI
import WWSimpleVideoPlayerViewUI

/// 影片網址
struct ShortVideo: WWSimpleVideoPlayerDataSource {
    
    let id: UUID = .init()
    var url: URL
}
