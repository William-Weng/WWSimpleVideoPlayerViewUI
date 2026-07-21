//
//  VideoPlayerManager.swift
//  Example
//
//  Created by William.Weng on 2026/7/9.
//

import AVFoundation
import Observation

/// 影片播放管理器
/// 負責：
/// - 持有 AVPlayer
/// - 控制播放 / 暫停 / 停止
/// - 載入影片
/// - 監聽播放時間與 buffer 進度
@Observable
final class VideoPlayerManager {
    
    @ObservationIgnored
    let player: AVPlayer                                        // 播放核心
    
    var currentTime: Double = 0                                 // 目前播放時間（秒）
    var duration: Double = 0                                    // 影片總長度（秒）
    var bufferedTime: Double = 0                                // 已緩衝到的時間（秒）
    
    @ObservationIgnored
    private var timeObserver: Any?                              // 定期時間監聽 token
    
    @ObservationIgnored
    private var currentItemObservation: NSKeyValueObservation?  // 目前影片項目的 KVO 監聽
    
    init() {
        player = .init()
        setupTimeObserver()
    }
    
    deinit {
        teardown()
    }
}

// MARK: - 公開API
extension VideoPlayerManager {
    
    /// 是否正在播放
    var isPlaying: Bool {
        player.timeControlStatus == .playing
    }
    
    /// 是否正在緩衝
    var isBuffering: Bool {
        player.timeControlStatus == .waitingToPlayAtSpecifiedRate
    }
}

// MARK: - 公開API
extension VideoPlayerManager {
    
    /// 開始播放
    func play() {
        player.play()
    }
    
    /// 暫停播放
    func pause() {
        player.pause()
    }
    
    /// 停止播放 (先暫停，再回到開頭)
    func stop() {
        player.pause()
        player.seek(to: .zero)
    }
    
    /// 載入影片
    /// - Parameter url: 影片網址
    func loadVideo(url: URL) {
        
        removeCurrentItemObservation()
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        observeItem(item)
        refreshCurrentState()
    }
    
    /// 跳轉播放位置
    /// - Parameter seconds: 目標秒數
    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player.seek(to: time)
    }
    
    /// 停止並釋放播放器相關資源
    ///
    /// 建議在以下時機呼叫：
    /// - View 即將消失時
    /// - 不再需要播放影片時
    /// - 想要明確中止目前影片播放與監聽時
    func teardown() {
        player.pause()
        removeTimeObserver()
        removeCurrentItemObservation()
        player.replaceCurrentItem(with: nil)
    }
}

// MARK: - 私有API
private extension VideoPlayerManager {
    
    /// 建立定期時間監聽 (每 0.5 秒更新一次目前播放狀態)
    func setupTimeObserver() {
        
        removeTimeObserver()
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.refreshCurrentState()
        }
    }
    
    /// 監聽目前 item 的緩衝範圍
    /// 當 loadedTimeRanges 變化時，更新 buffer 進度
    func observeItem(_ item: AVPlayerItem) {
        
        currentItemObservation = item.observe(\.loadedTimeRanges, options: [.initial, .new]) { [weak self] item, _ in
            self?.bufferedTime = self?.calculateBufferedTime(from: item) ?? 0
        }
    }
    
    /// 刷新目前播放狀態 (統一更新 currentTime / duration / bufferedTime)
    func refreshCurrentState() {
        
        guard let item = player.currentItem else {
            currentTime = 0
            duration = 0
            bufferedTime = 0
            return
        }
        
        currentTime = player.currentTime().seconds
        duration = item.duration.seconds.isFinite ? item.duration.seconds : 0
        bufferedTime = calculateBufferedTime(from: item)
    }
    
    /// 計算已緩衝時間
    /// - Parameter item: 目前播放項目
    /// - Returns: 緩衝到的秒數
    func calculateBufferedTime(from item: AVPlayerItem) -> Double {
        guard let range = item.loadedTimeRanges.first?.timeRangeValue else { return 0 }
        return CMTimeGetSeconds(range.start + range.duration)
    }
    
    /// 移除定期時間監聽
    func removeTimeObserver() {
        
        guard let timeObserver else { return }
        
        player.removeTimeObserver(timeObserver)
        self.timeObserver = nil
    }
    
    /// 移除 item 的 KVO 監聽
    func removeCurrentItemObservation() {
        currentItemObservation = nil
    }
}
