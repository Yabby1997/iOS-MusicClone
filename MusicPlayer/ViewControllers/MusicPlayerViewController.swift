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
            static let pauseLeading: CGFloat = 64
            static let pauseTrailing: CGFloat = -64
            static let pauseBottom: CGFloat = -30
            static let playingLeading: CGFloat = 32
            static let playingTrailing: CGFloat = -32
            static let playingBottom: CGFloat = 2
            static let playingShadowOpacity: Float = 0.6
            static let pauseShadowOpacity: Float = 0.3
            static let cornerRadius: CGFloat = 12
            static let shadowOffset = CGSize(width: 0, height: 5)
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
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let darkOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private let artworkContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = Design.ArtworkImageView.pauseShadowOpacity
        view.layer.shadowOffset = Design.ArtworkImageView.shadowOffset
        view.layer.shadowRadius = Design.ArtworkImageView.cornerRadius
        return view
    }()
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Design.ArtworkImageView.cornerRadius
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.TitleLabel.font
        label.text = "Not Playing"
        label.textColor = Design.TitleLabel.fontColor
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = Design.ArtistLabel.font
        label.text = " "
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
        self.musicPlayer = musicPlayer
    }
    
    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        setupPlayer()
    }

    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(darkOverlayView)
        darkOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(artworkContainerView)
        artworkContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Design.ArtworkImageView.pauseLeading)
            make.trailing.equalToSuperview().offset(Design.ArtworkImageView.pauseTrailing)
            make.bottom.equalTo(view.snp.centerY).offset(Design.ArtworkImageView.pauseBottom)
            make.height.equalTo(artworkContainerView.snp.width)
        }
        
        artworkContainerView.addSubview(artworkImageView)
        artworkImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        rewindButton.addTarget(self, action: #selector(rewindButtonDidTap), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonDidTap), for: .touchUpInside)
        rewindButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(rewindButtoDidLongPressed)))
        forwardButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(forwardButtonDidLongPressed)))
    }
    
    private func setupPlayer() {
        musicPlayer?.delegate = self
        musicPlayer?.reload()
    }
    
    // MARK: - Actions
    
    @objc func mediaSeekBarValueChanged(_ sender: MediaSeekBar) {
        musicPlayer?.seekBarValueChanged(to: mediaSeekBar.progress)
    }
    
    @objc func rewindButtonDidTap(_ sender: UIButton) {
        musicPlayer?.rewindButtonDidTap()
    }
    
    @objc func forwardButtonDidTap(_ sender: UIButton) {
        musicPlayer?.forwardButtonDidTap()
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
        let artworkImage = UIImage(data: imageData)
        
        artworkImageView.image = artworkImage
        UIView.transition(
            with: backgroundView, duration: 1.0,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.backgroundView.image = artworkImage?.blur(radius: 100)
        }
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
            artworkContainerView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(Design.ArtworkImageView.playingLeading)
                make.trailing.equalToSuperview().offset(Design.ArtworkImageView.playingTrailing)
                make.bottom.equalTo(view.snp.centerY).offset(Design.ArtworkImageView.playingBottom)
            }
        } else {
            playPauseButton.setImage(.playFill, for: .normal)
            artworkContainerView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(Design.ArtworkImageView.pauseLeading)
                make.trailing.equalToSuperview().offset(Design.ArtworkImageView.pauseTrailing)
                make.bottom.equalTo(view.snp.centerY).offset(Design.ArtworkImageView.pauseBottom)
            }
        }
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn
        ) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.artworkContainerView.layer.shadowOpacity = isPlaying
                ? Design.ArtworkImageView.playingShadowOpacity
                : Design.ArtworkImageView.pauseShadowOpacity
        }
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didPlayed playedTime: CMTime, inTotal duration: CMTime) {
        mediaSeekBar.updateProgress(playedTime: playedTime, duration: duration)
    }
}
