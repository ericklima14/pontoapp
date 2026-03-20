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
    
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(videoName: videoName, videoType: videoType)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        
        guard let fileURL = Bundle.main.url(forResource: videoName, withExtension: videoType) else { return }
        
        let asset = AVAsset(url: fileURL)
        let item = AVPlayerItem(asset: asset)
        
        let player = AVQueuePlayer(playerItem: item)
        self.queuePlayer = player
        
        player.automaticallyWaitsToMinimizeStalling = false
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        player.playImmediately(atRate: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
