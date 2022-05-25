//
//  UIImage+Extensions.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import UIKit
import CoreImage.CIFilterBuiltins

// MARK: - Static Icons

extension UIImage {
    enum Icon {
        static let playFill = UIImage(systemName: "play.fill")
        static let pauseFill = UIImage(systemName: "pause.fill")
        static let backwardFill = UIImage(systemName: "backward.fill")
        static let forwardFill = UIImage(systemName: "forward.fill")
        static let speakerFill = UIImage(systemName: "speaker.fill")
        static let speakerWave3Fill = UIImage(systemName: "speaker.wave.3.fill")
    }
}

// MARK: - Features

extension UIImage {
    func blur(radius: Float) -> UIImage? {
        let context = CIContext()
        
        guard let ciImage = CIImage(image: self) else { return self }
        
        let clampFilter = CIFilter.affineClamp()
        let blurFilter = CIFilter.gaussianBlur()
        
        clampFilter.inputImage = ciImage
        blurFilter.inputImage = clampFilter.outputImage
        blurFilter.radius = radius
        
        guard let output = blurFilter.outputImage,
              let cgimg = context.createCGImage(output, from: ciImage.extent) else { return self }
        
        return UIImage(cgImage: cgimg)
    }
}
