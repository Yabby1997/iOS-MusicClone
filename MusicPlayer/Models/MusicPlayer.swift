//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import AVFoundation
import Foundation

protocol MusicPlayerDelegate: AnyObject {
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadArtworkImageData imageData: Data)
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadTitle title: String)
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadArtist artist: String)
}

class MusicPlayer {
    var player: AVAudioPlayer?
    
    weak var delegate: MusicPlayerDelegate?
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "피카부", ofType:"mp3") else { return }
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        
        let metaData = asset.commonMetadata
        
        let artworkItems = AVMetadataItem.metadataItems(from: metaData, filteredByIdentifier: .commonIdentifierArtwork)
    
        if let artworkItem = artworkItems.first {
            guard let data = artworkItem.dataValue else { return }
            delegate?.musicPlayer(self, didLoadArtworkImageData: data)
        }
        
        let titleItems = AVMetadataItem.metadataItems(from: metaData, filteredByIdentifier: .commonIdentifierTitle)
        if let titleItem = titleItems.first {
            guard let title = titleItem.stringValue else { return }
            delegate?.musicPlayer(self, didLoadTitle: title)
        }
        
        let artistItems = AVMetadataItem.metadataItems(from: metaData, filteredByIdentifier: .commonIdentifierArtist)
        if let artistItem = artistItems.first {
            guard let artist = artistItem.stringValue else { return }
            delegate?.musicPlayer(self, didLoadArtist: artist)
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func seek(to progress: Double) {
        guard let duration = player?.duration else { return }
        player?.currentTime = duration * progress / 100.0
    }

    func setVolume(to percentage: Float) {
        player?.setVolume(percentage, fadeDuration: 0.1)
    }
}
