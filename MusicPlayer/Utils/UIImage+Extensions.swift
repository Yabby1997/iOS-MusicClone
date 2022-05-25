//
//  UIImage+Extensions.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import UIKit
import CoreImage.CIFilterBuiltins

extension UIImage {
    static let playFill = UIImage(systemName: "play.fill")
    static let pauseFill = UIImage(systemName: "pause.fill")
    static let backwardFill = UIImage(systemName: "backward.fill")
    static let forwardFill = UIImage(systemName: "forward.fill")
    static let speakerFill = UIImage(systemName: "speaker.fill")
    static let speakerWave3Fill = UIImage(systemName: "speaker.wave.3.fill")
}

extension UIImage {
    func blur(radius: Float) -> UIImage? {
        let context = CIContext()
        
        guard let ciImage = CIImage(image: self),
                let clampFilter = CIFilter(name: "CIAffineClamp"),
                let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            return self
        }
        
        clampFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let output = blurFilter.outputImage,
              let cgimg = context.createCGImage(output, from: ciImage.extent) else {
            return self
        }
        return UIImage(cgImage: cgimg)
    }
}
