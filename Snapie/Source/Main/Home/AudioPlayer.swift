//
//  AudioPlayer.swift
//  Snapie
//
//  Created by 남경민 on 2023/09/01.
//

import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
}
