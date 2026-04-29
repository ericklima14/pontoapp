import AVFoundation

class VideoPreloader {
    static let shared = VideoPreloader()
    
    private var cachedAssets: [String: AVURLAsset] = [:]
    private var cachedPlayers: [String: AVQueuePlayer] = [:]
    private var cachedLoopers: [String: AVPlayerLooper] = [:]
    private var cachedItems: [String: AVPlayerItem] = [:]
    
    func preload(videoName: String, videoType: String) {
        let key = "\(videoName).\(videoType)"
        guard cachedAssets[key] == nil else { return }
        
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else { return }
        let asset = AVURLAsset(url: url)
        cachedAssets[key] = asset
        
        Task {
            _ = try? await asset.load(.isPlayable)
            
            let item = AVPlayerItem(asset: asset)
            let player = AVQueuePlayer(playerItem: item)
            let looper = AVPlayerLooper(player: player, templateItem: item)
            player.automaticallyWaitsToMinimizeStalling = false
            player.play()  // aquece em background
            
            await MainActor.run {
                self.cachedItems[key] = item
                self.cachedPlayers[key] = player
                self.cachedLoopers[key] = looper
                print("Player \(key) pré-aquecido e pronto")
            }
        }
    }
    
    func asset(videoName: String, videoType: String) -> AVURLAsset? {
        cachedAssets["\(videoName).\(videoType)"]
    }
    
    // Novo — retorna o player já pronto
    func playerReady(videoName: String, videoType: String) -> (AVQueuePlayer, AVPlayerLooper, AVPlayerItem)? {
        let key = "\(videoName).\(videoType)"
        guard let p = cachedPlayers[key],
              let l = cachedLoopers[key],
              let i = cachedItems[key] else { return nil }
        return (p, l, i)
    }
}
