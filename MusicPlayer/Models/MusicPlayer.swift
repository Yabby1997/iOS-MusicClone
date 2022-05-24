//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import AVFoundation
import Foundation

protocol MusicPlayerDelegate: AnyObject {
    func musicPlayer(_ musicPlayer: MusicPlayer, errorDidOccurred error: Error)
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadArtwork imageData: Data)
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadTitle title: String)
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadArtist artist: String)
    func musicPlayer(_ musicPlayer: MusicPlayer, didChangePlaybackStatus isPlaying: Bool)
}

class MusicPlayer {
    var url: URL? {
        didSet {
            loadMetadata()
            loadPlayer()
        }
    }
    
    private var player: AVAudioPlayer?
    weak var delegate: MusicPlayerDelegate?
    
    private var isPlaying: Bool { player?.isPlaying ?? false }
    
    private func loadMetadata() {
        guard let url = url else { return }
        
        let asset = AVAsset(url: url)
        let metaData = asset.commonMetadata
        
        let artworkItems = AVMetadataItem.metadataItems(from: metaData, filteredByIdentifier: .commonIdentifierArtwork)
        if let artworkItem = artworkItems.first {
            guard let data = artworkItem.dataValue else { return }
            delegate?.musicPlayer(self, didLoadArtwork: data)
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
    }
    
    private func loadPlayer() {
        guard let url = url else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            delegate?.musicPlayer(self, errorDidOccurred: error)
        }
    }
    
    func playPauseButtonDidTap() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        delegate?.musicPlayer(self, didChangePlaybackStatus: isPlaying)
    }
    
    func seek(to progress: Double) {
        guard let duration = player?.duration else { return }
        player?.currentTime = duration * progress / 100.0
    }
}
