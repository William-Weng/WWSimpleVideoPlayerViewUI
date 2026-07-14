//
//  BlurView.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import SwiftUI

// MARK: - 輔助元件：UIKit 毛玻璃效果
struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        .init(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
