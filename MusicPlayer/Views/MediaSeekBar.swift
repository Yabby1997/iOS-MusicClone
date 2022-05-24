//
//  MediaSeekBar.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import AVKit
import UIKit

class MediaSeekBar: UIControl {
    
    // MARK: - Constants
    
    enum Design {
        enum Label {
            static let top: CGFloat = 12
        }
    }
    
    // MARK: - Subviews
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 0
        return slider
    }()
    
    private let playedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "--:--"
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "--:--"
        return label
    }()
    
    // MARK: - Properties
    
    private var didEndEditing: Bool = false
    private var duration: Double = .zero
    private(set) var progress: Float {
        get { slider.value }
        set {
            slider.value = newValue
            updateTimeLabels()
        }
    }
    
    var sliderTintColor: UIColor? { didSet { slider.tintColor = sliderTintColor } }
    var thumbColor: UIColor? { didSet { updateThumb() } }
    var thumbWidth: CGFloat? { didSet { updateThumb() } }
    
    var font: UIFont? {
        didSet {
            playedTimeLabel.font = font
            remainingTimeLabel.font = font
        }
    }
    
    var textColor: UIColor? {
        didSet {
            playedTimeLabel.textColor = textColor
            remainingTimeLabel.textColor = textColor
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        addSubview(slider)
        slider.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderValueEditDidEnd), for: [.touchUpInside, .touchUpOutside])
        
        addSubview(playedTimeLabel)
        playedTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(Design.Label.top)
            make.bottom.equalToSuperview()
        }
        
        addSubview(remainingTimeLabel)
        remainingTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(Design.Label.top)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Private methods
    
    private func updateThumb() {
        guard let width = thumbWidth,
              let color = thumbColor else { return }
        slider.setThumbImage(generateThumbImage(size: width, color: color), for: .normal)
    }
    
    private func generateThumbImage(size: CGFloat, color: UIColor) -> UIImage {
        let thumbView: UIView = {
            let view = UIView()
            view.backgroundColor = color
            return view
        }()
        
        thumbView.frame = CGRect(x: 0, y: size / 2, width: size, height: size)
        thumbView.layer.cornerRadius = size / 2
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { thumbView.layer.render(in: $0.cgContext) }
    }
    
    private func updateTimeLabels() {
        func getTimeString(with time: Double) -> String {
            let minutes = Int(time / 60.0)
            let seconds = Int(time.truncatingRemainder(dividingBy: 60.0))
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        let seekingTime = duration * (Double(progress) / 100.0)
        let remainingTime = duration - seekingTime
        
        playedTimeLabel.text = getTimeString(with: seekingTime)
        remainingTimeLabel.text = "-" + getTimeString(with: remainingTime)
    }
    
    func updateProgress(playedTime: CMTime, duration: CMTime) {
        if slider.isTracking { return }
        if didEndEditing { return didEndEditing = false }
        self.duration = duration.seconds
        progress = Float(playedTime.seconds / duration.seconds * 100)
    }
    
    // MARK: - Actions
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        updateTimeLabels()
    }
    
    @objc private func sliderValueEditDidEnd(_ sender: UISlider) {
        didEndEditing = true
        sendActions(for: .valueChanged)
    }
}
