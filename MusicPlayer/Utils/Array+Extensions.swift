//
//  Array+Extensions.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/25.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
