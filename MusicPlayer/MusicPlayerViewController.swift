//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import UIKit

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
        }
        
        enum MediaControl {
            static let buttonImageInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            static let buttonColor: UIColor = .white
        }
        
        enum SoundControl {
            static let tintColor: UIColor = .white.withAlphaComponent(0.7)
        }
    }
    
    // MARK: - Subviews
    
    private let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
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
    
    private let soundLevelSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.tintColor = Design.SoundControl.tintColor
        return slider
    }()
    
    private let soundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()

    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
            make.top.equalTo(artistLabel.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        view.addSubview(mediaControlStackView)
        mediaControlStackView.snp.makeConstraints { make in
            make.top.equalTo(mediaSeekBar.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(48)
            make.trailing.equalToSuperview().offset(-48)
            make.height.equalTo(50)
        }
        
        mediaControlStackView.addArrangedSubview(rewindButton)
        rewindButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        mediaControlStackView.addArrangedSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        mediaControlStackView.addArrangedSubview(forwardButton)
        forwardButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        view.addSubview(soundStackView)
        soundStackView.snp.makeConstraints { make in
            make.top.equalTo(mediaControlStackView.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        soundStackView.addArrangedSubview(lowSoundImageView)
        lowSoundImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
        }
        
        soundStackView.addArrangedSubview(soundLevelSlider)
        
        soundStackView.addArrangedSubview(highSoundImageView)
        highSoundImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
        }
    }
}
