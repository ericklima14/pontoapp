//
//  LoopingPlayerView.swift
//  pontoapp
//
//  Created by Erick Costa Reimberg de Lima on 19/02/26.
//

import SwiftUI
import AVFoundation

struct LoopingPlayerView: UIViewRepresentable {
    let videoName: String
    let videoType: String
    var onReady: (() -> Void)?
    
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(videoName: videoName, videoType: videoType, onReady: onReady)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    var onReady: (() -> Void)?
    
    init(videoName: String, videoType: String, onReady: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.onReady = onReady

        layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        
        if let (player, looper, _) = VideoPreloader.shared.playerReady(videoName: videoName, videoType: videoType) {
            self.queuePlayer = player
            self.playerLooper = looper
            self.playerLayer.player = player
            player.rate = 1.0
            waitForFirstFrame(completion: onReady)
            return
        }
        
        guard let fileURL = Bundle.main.url(forResource: videoName, withExtension: videoType) else { return }
        
        Task {
            do {
                let asset = VideoPreloader.shared.asset(videoName: videoName, videoType: videoType)
                                ?? AVURLAsset(url: fileURL)
                
                _ = try await asset.load(.isPlayable)
                
                let item = AVPlayerItem(asset: asset)
                let player = AVQueuePlayer(playerItem: item)
                
                player.automaticallyWaitsToMinimizeStalling = false
                
                await MainActor.run {
                    self.queuePlayer = player
                    self.playerLayer.player = player
                    self.playerLooper = AVPlayerLooper(player: player, templateItem: item)
                    player.playImmediately(atRate: 1.0)

                    self.waitForFirstFrame(completion: self.onReady)
                }
            } catch {
                print("Erro ao carregar vídeo: \(error)")
            }
        }
    }
    
    private func waitForFirstFrame(completion: (() -> Void)?) {
        if playerLayer.isReadyForDisplay {
            completion?()
            return
        }
        
        var observation: NSKeyValueObservation?
        observation = playerLayer.observe(\.isReadyForDisplay, options: [.new]) { layer, change in
            if change.newValue == true {
                DispatchQueue.main.async {
                    completion?()
                }
                observation?.invalidate()
                observation = nil
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
