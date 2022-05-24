//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import UIKit
import MediaPlayer

import SnapKit

class MusicPlayerViewController: UIViewController {
    
    // MARK: - Constants
    
    enum Design {
        enum ArtworkImageView {
            static let leading: CGFloat = 64
            static let trailing: CGFloat = -64
            static let bottom: CGFloat = -30
            static let cornerRadius: CGFloat = 12
        }
        
        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 22, weight: .semibold)
            static let top: CGFloat = 48
            static let leading: CGFloat = 32
            static let trailing: CGFloat = -32
            static let fontColor: UIColor = .white
        }
        
        enum ArtistLabel {
            static let font: UIFont = .systemFont(ofSize: 22, weight: .regular)
            static let top: CGFloat = 0
            static let leading: CGFloat = TitleLabel.leading
            static let trailing: CGFloat = TitleLabel.trailing
            static let fontColor: UIColor = .white.withAlphaComponent(0.7)
        }
        
        enum MediaSeekBar {
            static let thumbWidth: CGFloat = 7
            static let thumbColor: UIColor = .white
            static let sliderTintColor: UIColor = .white.withAlphaComponent(0.7)
            static let textColor: UIColor = .white.withAlphaComponent(0.5)
            static let font: UIFont = .systemFont(ofSize: 12, weight: .bold)
            static let top: CGFloat = 22
            static let leading: CGFloat = 32
            static let trailing: CGFloat = -32
        }
        
        enum MediaControl {
            static let buttonImageInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            static let buttonColor: UIColor = .white
            static let top: CGFloat = 48
            static let leading: CGFloat = 48
            static let trailing: CGFloat = -48
            static let height: CGFloat = 50
            static let buttonWidth: CGFloat = 50
        }
        
        enum SoundControl {
            static let tintColor: UIColor = .white.withAlphaComponent(0.7)
            static let top: CGFloat = 48
            static let leading: CGFloat = 32
            static let trailing: CGFloat = -32
            static let imageWidth: CGFloat = 12
            static let spacing: CGFloat = 12
        }
    }
    
    // MARK: - Subviews
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Design.ArtworkImageView.cornerRadius
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.TitleLabel.font
        label.text = "Italo Disco"
        label.textColor = Design.TitleLabel.fontColor
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = Design.ArtistLabel.font
        label.text = "Last Dinosaurs"
        label.textColor = Design.ArtistLabel.fontColor
        return label
    }()
    
    private let mediaSeekBar: MediaSeekBar = {
        let mediaSeekBar = MediaSeekBar()
        mediaSeekBar.thumbWidth = Design.MediaSeekBar.thumbWidth
        mediaSeekBar.thumbColor = Design.MediaSeekBar.thumbColor
        mediaSeekBar.sliderTintColor = Design.MediaSeekBar.sliderTintColor
        mediaSeekBar.textColor = Design.MediaSeekBar.textColor
        mediaSeekBar.font = Design.MediaSeekBar.font
        return mediaSeekBar
    }()
    
    private let rewindButton: UIButton = {
        let button = UIButton()
        button.setImage(.backwardFill, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = Design.MediaControl.buttonImageInset
        button.tintColor = Design.MediaControl.buttonColor
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(.playFill, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .white
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(.forwardFill, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = Design.MediaControl.buttonImageInset
        button.tintColor = Design.MediaControl.buttonColor
        return button
    }()
    
    private let mediaControlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let lowSoundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .speakerFill
        imageView.tintColor = Design.SoundControl.tintColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let highSoundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .speakerWave3Fill
        imageView.tintColor = Design.SoundControl.tintColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let volumeView: MPVolumeView = {
        let volumeView = MPVolumeView()
        volumeView.tintColor = Design.SoundControl.tintColor
        volumeView.showsRouteButton = false
        return volumeView
    }()

    private let soundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Design.SoundControl.spacing
        return stackView
    }()
    
    // MARK: - Properties
    
    var musicPlayer: MusicPlayer?

    // MARK: - Initializers
    
    convenience init(musicPlayer: MusicPlayer) {
        self.init(nibName: nil, bundle: nil)
        musicPlayer.delegate = self
        self.musicPlayer = musicPlayer
    }
    
    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        selectMusic()
    }

    // MARK: - Setups
    
    private func setupViews() {
        view.backgroundColor = .systemGray
        
        view.addSubview(artworkImageView)
        artworkImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Design.ArtworkImageView.leading)
            make.trailing.equalToSuperview().offset(Design.ArtworkImageView.trailing)
            make.bottom.equalTo(view.snp.centerY).offset(Design.ArtworkImageView.bottom)
            make.height.equalTo(artworkImageView.snp.width)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(Design.TitleLabel.top)
            make.leading.equalToSuperview().offset(Design.TitleLabel.leading)
            make.trailing.equalToSuperview().offset(Design.TitleLabel.trailing)
        }
        
        view.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Design.ArtistLabel.top)
            make.leading.equalToSuperview().offset(Design.ArtistLabel.leading)
            make.trailing.equalToSuperview().offset(Design.ArtistLabel.trailing)
        }
        
        view.addSubview(mediaSeekBar)
        mediaSeekBar.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(Design.MediaSeekBar.top)
            make.leading.equalToSuperview().offset(Design.MediaSeekBar.leading)
            make.trailing.equalToSuperview().offset(Design.MediaSeekBar.trailing)
        }
        
        view.addSubview(mediaControlStackView)
        mediaControlStackView.snp.makeConstraints { make in
            make.top.equalTo(mediaSeekBar.snp.bottom).offset(Design.MediaControl.top)
            make.leading.equalToSuperview().offset(Design.MediaControl.leading)
            make.trailing.equalToSuperview().offset(Design.MediaControl.trailing)
            make.height.equalTo(Design.MediaControl.height)
        }
        
        mediaControlStackView.addArrangedSubview(rewindButton)
        rewindButton.snp.makeConstraints { make in
            make.width.equalTo(Design.MediaControl.buttonWidth)
        }
        
        mediaControlStackView.addArrangedSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.width.equalTo(Design.MediaControl.buttonWidth)
        }
        
        mediaControlStackView.addArrangedSubview(forwardButton)
        forwardButton.snp.makeConstraints { make in
            make.width.equalTo(Design.MediaControl.buttonWidth)
        }

        view.addSubview(soundStackView)
        soundStackView.snp.makeConstraints { make in
            make.top.equalTo(mediaControlStackView.snp.bottom).offset(Design.SoundControl.top)
            make.leading.equalToSuperview().offset(Design.SoundControl.leading)
            make.trailing.equalToSuperview().offset(Design.SoundControl.trailing)
        }

        soundStackView.addArrangedSubview(lowSoundImageView)
        soundStackView.addArrangedSubview(volumeView)
        soundStackView.addArrangedSubview(highSoundImageView)
    }
    
    private func setupActions() {
        mediaSeekBar.addTarget(self, action: #selector(mediaSeekBarValueChanged), for: .valueChanged)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonDidTap), for: .touchUpInside)
        rewindButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(rewindButtoDidLongPressed)))
        forwardButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(forwardButtonDidLongPressed)))
    }
    
    private func selectMusic() {
        let path = Bundle.main.path(forResource: "피카부", ofType:"mp3")
        let url = URL(fileURLWithPath: path ?? "")
        musicPlayer?.url = url
    }
    
    // MARK: - Actions
    
    @objc func mediaSeekBarValueChanged(_ sender: MediaSeekBar) {
        musicPlayer?.seek(to: mediaSeekBar.progress)
    }
    
    @objc func rewindButtoDidLongPressed(_ sender: UILongPressGestureRecognizer) {
        print(#function)
    }
    
    @objc func forwardButtonDidLongPressed(_ sender: UILongPressGestureRecognizer) {
        print(#function)
    }
    
    @objc func playPauseButtonDidTap(_ sender: UIButton) {
        musicPlayer?.playPauseButtonDidTap()
    }
}

extension MusicPlayerViewController: MusicPlayerDelegate {
    func musicPlayer(_ musicPlayer: MusicPlayer, errorDidOccurred error: Error) {
        print(error.localizedDescription)
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadArtwork imageData: Data) {
        artworkImageView.image = UIImage(data: imageData)
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadTitle title: String) {
        titleLabel.text = title
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadArtist artist: String) {
        artistLabel.text = artist
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didChangePlaybackStatus isPlaying: Bool) {
        if isPlaying {
            playPauseButton.setImage(.pauseFill, for: .normal)
        } else {
            playPauseButton.setImage(.playFill, for: .normal)
        }
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didLoadDuration duration: TimeInterval) {
        mediaSeekBar.duration = duration
    }
}
