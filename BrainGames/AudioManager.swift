//
//  AudioManager.swift
//  Brain Train
//
//  Created by Ogechi Nwankwo on 11/1/23.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    public var audioPlayer: AVAudioPlayer?

    private init() {
        // Load and configure background music
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
                audioPlayer?.numberOfLoops = -1 // Infinite loop
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading background music: \(error)")
            }
        }
    }

    func playBackgroundMusic() {
        audioPlayer?.play()
    }

    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}
