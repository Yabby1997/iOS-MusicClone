//
//  SceneDelegate.swift
//  MusicPlayer
//
//  Created by Seunghun Yang on 2022/05/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let musicPlayer = MusicPlayer(musics: [
            .peek_a_boo,
            .italo_disco,
            .tkm
        ])
        
        let musicPlayerViewController = MusicPlayerViewController(musicPlayer: musicPlayer)
        
        window.rootViewController = musicPlayerViewController
        window.makeKeyAndVisible()
    }
}

