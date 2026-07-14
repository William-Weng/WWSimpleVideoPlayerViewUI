//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/7/7.
//

import AVKit
import SwiftUI

public struct WWSimpleVideoPlayerViewUI<T: WWSimpleVideoPlayerDataSource>: View {
    
    @Binding private var source: T                                  // 影片資源的 URL
    @Binding private var isAutoplay: Bool                           // 是否自動播放
    
    @State private var manager = VideoPlayerManager()               // 影片播放器管理器（包含 AVPlayer、縮圖生成器等）
    
    @State private var brightness: Double = 0.0                     // 當前螢幕亮度（0.0 ~ 1.0）
    @State private var baseBrightness: Double = 0.0                 // 拖動開始時的基準亮度（用於計算亮度變化量）
    
    @State private var volume: Double = 0.0                         // 當前系統音量（0.0 ~ 1.0）
    @State private var baseVolume: Double = 0.0                     // 拖動開始時的基準音量（用於計算音量變化量）
    
    @State private var showHUD: Bool = false                        // 是否顯示 HUD 視窗
    @State private var hudType: HUDType = .brightness               // 當前 HUD 類型（亮度 / 音量 / 進度）
    @State private var hudTimer: Timer? = nil                       // HUD 自動關閉計時器
    
    @State private var currentDirection: DragDirection = .unknown   // 當前拖動方向（水平 / 垂直 / 未知）
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                ZStack {
                    VideoPlayer(player: manager.player)
                        .contentShape(Rectangle())
                        .highPriorityGesture(videoDragGesture(screenWidth: geometry.size.width))
                        .ignoresSafeArea()
                    hudOverlayView
                    HiddenVolumeView()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                }
            }.task {
                initPlayer(url: source.url)
                initConfigure()
            }
            .onChange(of: source.url) { _, newUrl in
                initPlayer(url: newUrl)
                initConfigure()
            }
            .onDisappear {
                hudTimer?.invalidate()
                hudTimer = nil
            }
        }
    }
    
    /// [簡易影片播放器視圖](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/swiftui-產生-gesture-的三個寫法-48097455832d)
    ///
    /// 主要功能：
    /// - 使用 `VideoPlayer` 播放指定 URL 的影片
    /// - 支援拖動交互：
    ///   - 上下拖動（左區）：調整螢幕亮度
    ///   - 上下拖動（右區）：調整系統音量
    /// - 使用 `hudOverlayView` 顯示 HUD（亮度條、音量條、進度條等）
    /// Description
    /// - Parameters:
    ///   - source: 影片資源
    ///   - isAutoplay: 是否自動播放
    public init(source: Binding<T>, isAutoplay: Binding<Bool>) {
        _source = source
        _isAutoplay = isAutoplay
    }
}

// MARK: - 子視圖
private extension WWSimpleVideoPlayerViewUI {
    
    /// HUD 提示視窗（亮度條、音量條、快轉進度等）
    ///
    /// 根據 `hudType` 動態調整視窗大小：
    /// - `.progress`（快轉）：加大視窗以容納 16:9 縮圖
    /// - 其他（亮度 / 音量）：使用較小視窗
    ///
    /// 包含以下内容：
    /// - 亮度 / 音量時：iconView + progressBarView
    ///
    /// 動態調整 HUD 視窗大小：
    /// - 亮度 / 音量：90 x 70（僅顯示 icon + 進度條）
    ///
    /// HUD 的顯示 / 隱藏通過 `showHUD` 控制 `opacity`，並使用動畫
    @ViewBuilder
    var hudOverlayView: some View {
        
        let size: CGSize = .init(width: 90, height: 70)
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.black.opacity(0.001))
                .background(
                    BlurView(style: .systemMaterialDark)
                        .frame(width: size.width, height: size.height)
                )
                .opacity(0.8)

            VStack(spacing: 12) {
                iconView
                progressBarView
                    .frame(height: 6)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .frame(width: size.width, height: size.height)
        .cornerRadius(16)
        .shadow(radius: 10)
        .opacity(showHUD ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.2), value: showHUD)
    }
    
    /// 亮度 / 音量 icon 視圖
    ///
    /// 使用 `hudIcon`（例如 "brightness.up" / "volume"）來顯示對應圖示
    var iconView: some View {
        Image(systemName: hudIcon)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .contentTransition(.symbolEffect(.replace))
    }
        
    /// 亮度 / 音量進度條視圖
    ///
    /// 使用 `GeometryReader` 取得父容器寬度，然後根據：
    /// - `brightness`：亮度進度條長度
    /// - `volume`：音量進度條長度
    /// 來計算前景條的寬度
    var progressBarView: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                Capsule()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * CGFloat(hudType == .brightness ? brightness : volume))
            }
        }
    }
}

// MARK: - 私有屬性
private extension WWSimpleVideoPlayerViewUI {
    
    /// 動態圖示判斷
    var hudIcon: String {
        switch hudType {
        case .brightness: return brightnessIcon
        case .volume: return volumeIcon
        }
    }
}

// MARK: - 動態圖示判斷
private extension WWSimpleVideoPlayerViewUI {
    
    /// 依音量大小動態更換喇叭圖示
    var volumeIcon: String {
        if volume == 0 { return "speaker.slash.fill" }
        if volume < 0.33 { return "speaker.wave.1.fill" }
        if volume < 0.66 { return "speaker.wave.2.fill" }
        return "speaker.wave.3.fill"
    }
    
    /// 依亮度大小動態更換喇叭圖示
    var brightnessIcon: String {
        if brightness == 0 { return "moon" }
        if brightness < 0.33 { return "sun.horizon" }
        if brightness < 0.66 { return "sun.min.fill" }
        return "sun.max.fill"
    }
}

// MARK: - 私有API
private extension WWSimpleVideoPlayerViewUI {
    
    /// 初始化播放器功能
    func initPlayer(url: URL) {
        manager.loadVideo(url: url)
        if isAutoplay { manager.play() }
    }
    
    /// 初始化同步亮度 / 音量
    func initConfigure() {
        
        let currentBrightness = Double(SystemBrightnessManager.shared.currentBrightness)
        brightness = currentBrightness
        baseBrightness = currentBrightness
        
        let currentVolume = Double(SystemVolumeManager.shared.currentVolume)
        volume = currentVolume
        baseVolume = currentVolume
    }
}

// MARK: - 拖動手勢
private extension WWSimpleVideoPlayerViewUI {
    
    /// 定義影片區的拖動手勢
    ///
    /// 使用 `DragGesture(minimumDistance: 10)`：
    /// - minimumDistance: 拖動距離必須大於 10 pixels 才會被識別為拖動
    /// - onChanged: 拖動過程中持續調用 `videoDragGestureOnChanged`
    /// - onEnded: 拖動結束時調用 `videoDragGestureOnEnded`
    ///
    /// - Parameters:
    ///   - screenWidth: 螢幕寬度（用於計算區域分界）
    func videoDragGesture(screenWidth: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { videoDragGestureOnChanged(screenWidth: screenWidth, value: $0) }
            .onEnded { videoDragGestureOnEnded(value: $0) }
    }
    
    /// 處理拖動過程中的事件（onChanged）
    ///
    /// 主要功能：
    /// 1. 取得螢幕寬度，用於判斷拖動區域（左 / 右 / 中間）
    /// 2. 根據拖動方向和區域，更新拖動狀態（水平快轉 / 垂直調整亮度/音量）
    /// 3. 顯示 HUD（提示視窗），並清除之前的 HUD 計時器
    ///
    /// - Parameters:
    ///   - screenWidth: 螢幕寬度（用於計算區域分界）
    ///   - value: DragGesture.Value，包含拖動距離、起始位置等資訊
    func videoDragGestureOnChanged(screenWidth: CGFloat, value: DragGesture.Value) {
        
        updateDragDirection(screenWidth: screenWidth, value: value)
        
        guard currentDirection == .vertical else { return }
        
        showHUD = true
        hudTimer?.invalidate()
        
        switch currentDirection {
        case .vertical: verticalDirectionAction(screenWidth: screenWidth, value: value)
        case .unknown: break
        }
    }
    
    /// 處理拖動結束時的事件（onEnded）
    ///
    /// 主要功能：
    /// 1. 如果是水平拖動，則執行快轉（seek）到目標時間
    /// 2. 更新基準亮度與音量（用於下次拖動）
    /// 3. 重置拖動方向為 `.unknown`
    /// 4. 設定 HUD 計時器，1 秒後關閉 HUD 並清除縮圖預覽
    ///
    /// - Parameter value: DragGesture.Value，包含拖動距離、起始位置等資訊
    func videoDragGestureOnEnded(value: DragGesture.Value) {
        
        baseBrightness = brightness
        baseVolume = volume
        currentDirection = .unknown
        
        hudTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            
            showHUD = false
            
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.2))
                hudType = .brightness
            }
        }
    }
}

// MARK: - 拖動更新
private extension WWSimpleVideoPlayerViewUI {
    
    /// 處理垂直拖動方向的操作（亮度 / 音量）
    ///
    /// 這個函式會：
    /// 1. 根據拖動起始位置判斷屬於哪個區域（左 / 右 / 中間）
    /// 2. 根據不同區域執行對應的操作：
    ///    - 左區（.left）：調整螢幕亮度，並顯示 brightness HUD
    ///    - 右區（.right）：調整系統音量，並顯示 volume HUD
    ///    - 中間（.center）：不做任何處理
    ///
    /// - Parameters:
    ///   - screenWidth: 螢幕寬度（用於計算區域分界）
    ///   - value: DragGesture.Value，包含拖動距離、起始位置等資訊
    func verticalDirectionAction(screenWidth: CGFloat, value: DragGesture.Value) {
        switch parseDragZone(screenWidth: screenWidth, value: value) {
        case .left: hudType = .brightness; updateScreenBrightness(value)
        case .right: hudType = .volume; updateSystemVolume(value)
        case .center: break
        }
    }
    
    /// 根據垂直拖動更新螢幕亮度
    ///
    /// 這個函式會：
    /// 1. 用 `baseBrightness` 減去 `value.translation.height` 乘以一個係數（0.003）
    ///    來計算新的亮度值。
    ///    - 向上拖動（translation.height < 0） → newBrightness 變大 → 亮度增加
    ///    - 向下拖動（translation.height > 0） → newBrightness 變小 → 亮度降低
    /// 2. 用 `max(0.0, min(1.0, ...))` 將亮度限制在 0.0 ~ 1.0 之間，避免超出範圍
    /// 3. 將結果寫入 `UIScreen.main.brightness`，實際調整螢幕亮度
    ///
    /// - Parameter value: DragGesture.Value，包含拖動距離等資訊
    func updateScreenBrightness(_ value: DragGesture.Value) {
        
        let newBrightness = baseBrightness - (value.translation.height * 0.003)
        
        brightness = max(0.0, min(1.0, newBrightness))
        SystemBrightnessManager.shared.setBrightness(brightness)
    }
    
    /// 根據垂直拖動更新系統音量
    ///
    /// 這個函式的邏輯與 `updateScreenBrightness` 類似：
    /// 1. 用 `baseVolume` 減去 `value.translation.height` 乘以係數（0.003）來計算新的音量值
    ///    - 向上拖動（translation.height < 0） → newVolume 變大 → 音量增加
    ///    - 向下拖動（translation.height > 0） → newVolume 變小 → 音量降低
    /// 2. 用 `max(0.0, min(1.0, ...))` 將音量限制在 0.0 ~ 1.0 之間
    /// 3. 呼叫 `SystemVolumeManager.setVolume` 來設定系統音量
    ///
    /// - Parameter value: DragGesture.Value，包含拖動距離等資訊
    func updateSystemVolume(_ value: DragGesture.Value) {
        
        let newVolume = baseVolume - (value.translation.height * 0.003)
        
        volume = max(0.0, min(1.0, newVolume))
        SystemVolumeManager.shared.setVolume(Float(volume))
    }
    
    /// 根據拖動起始位置，判斷當前屬於哪一個拖動區域（左 / 右 / 中間）
    ///
    /// 通常用在影片播放器中，根據手指在哪個區域開始拖動，來決定這次拖動代表什麼操作：
    /// - 左區：可能是快退 / 向左快轉
    /// - 右區：可能是快進 / 向右快轉
    /// - 中間：可能是普通 seek 或垂直操作（例如滑動列表）
    ///
    /// - Parameters:
    ///   - screenWidth: 螢幕寬度（用於計算 35% 與 65% 的區間）
    ///   - value: DragGesture.Value，包含拖動的起始位置、當前位置等資訊
    /// - Returns: 對應的 DragZone（.left / .right / .center）
    func parseDragZone(screenWidth: CGFloat, value: DragGesture.Value) -> DragZone {
        
        if (value.startLocation.x < screenWidth * 0.35) { return .left }
        if (value.startLocation.x > screenWidth * 0.65) { return .right }
        
        return .center
    }
    
    /// 更新拖動方向（水平快轉 / 垂直操作）
    ///
    /// 這個函式會根據手指拖動時的移動距離，判斷用戶是想做：
    /// - 水平拖動：左右快轉（seek）
    /// - 垂直拖動：可能是滑動列表、調整音量等
    ///
    /// 只有在「尚未決定方向（currentDirection == .unknown）」時才執行判斷，避免在拖動過程中重複設定方向
    ///
    /// - Parameters:
    ///   - screenWidth: 螢幕寬度（用於計算區域分界）
    ///   - value: DragGesture.Value，包含拖動距離、起始位置等資訊
    func updateDragDirection(screenWidth: CGFloat, value: DragGesture.Value) {
        
        guard currentDirection == .unknown else { return }
        
        let horizontalDistance = abs(value.translation.width)
        let verticalDistance = abs(value.translation.height)
        
        guard max(horizontalDistance, verticalDistance) > 10 else { return }
        guard verticalDistance > horizontalDistance else { return }
        
        switch parseDragZone(screenWidth: screenWidth, value: value) {
        case .left, .right: currentDirection = .vertical
        case .center: return
        }
    }
}
