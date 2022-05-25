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
    func musicPlayer(_ musicPlayer: MusicPlayer, didPlayed playedTime: CMTime, inTotal duration: CMTime)
}

class MusicPlayer {
    let musics: [URL]
    private var currentMusicIndex: Int? {
        didSet {
            loadMetadata()
            loadPlayer()
        }
    }
    
    private let player = AVPlayer()
    private var playbackTimeObservation: Any? = nil
    weak var delegate: MusicPlayerDelegate?
    
    private var duration: CMTime { player.currentItem?.duration ?? .zero }
    private var isPlaying: Bool { player.rate != 0 }
    private var url: URL? {
        guard let index = currentMusicIndex else { return nil }
        return musics[safe: index]
    }
    
    init(musics: [URL]) {
        self.musics = musics
        self.currentMusicIndex = musics.isEmpty ? nil : 0
    }
    
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

    func reload() {
        loadMetadata()
        loadPlayer()
    }
    
    private func loadPlayer() {
        guard let url = url else { return }
        let item = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: item)
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        playbackTimeObservation = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.delegate?.musicPlayer(self, didPlayed: time, inTotal: self.duration)
        }
    }
    
    func playPauseButtonDidTap() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        delegate?.musicPlayer(self, didChangePlaybackStatus: isPlaying)
    }
    
    func rewindButtonDidTap() {
        guard let index = currentMusicIndex,
              index > 0 else { return }
        currentMusicIndex = index - 1
    }
    
    func forwardButtonDidTap() {
        guard let index = currentMusicIndex,
              index + 1 < musics.count else { return }
        currentMusicIndex = index + 1
    }
    
    func seekBarValueChanged(to progress: Float) {
        let seekTime = CMTimeMultiplyByFloat64(duration, multiplier: Double(progress) / 100.0)
        player.seek(to: seekTime)
    }
}
