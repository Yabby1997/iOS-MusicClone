//
//  URL+Extensions.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/25.
//

import Foundation

extension URL {
    static let peek_a_boo = URL(fileURLWithPath: Bundle.main.path(forResource: "peek-a-boo", ofType:"mp3") ?? "")
    static let italo_disco = URL(fileURLWithPath: Bundle.main.path(forResource: "Italo Disco", ofType: "mp3") ?? "")
    static let tkm = URL(fileURLWithPath: Bundle.main.path(forResource: "tkm", ofType: "mp3") ?? "")
}
