//
//  TTSManager.swift
//  Snapie
//
//  Created by 남경민 on 2023/10/24.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit

class TTSManager : ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var isActive = false
    @Published var text : String?
    let placeholder = "원하시는 텍스트를 입력해주세요"
    static let shared = TTSManager()
    var audioUrl: URL?
    
    private let synthesizer = AVSpeechSynthesizer()
    
    internal func play() {
       // let utterance = AVSpeechUtterance(string: string)
        //utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        //utterance.rate = 0.4
        //synthesizer.stopSpeaking(at: .immediate)
        //synthesizer.speak(utterance)
        guard let text = text else {
            return
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        var output: AVAudioFile?

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioUrl:URL = documentsDirectory.appendingPathComponent(UUID().uuidString + ".caf")
        print(audioUrl)
        self.audioUrl = audioUrl
        
        
        synthesizer.write(utterance) { (buffer: AVAudioBuffer) in
            guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
                fatalError("unknown buffer type: \(buffer)")
            }
           
            if pcmBuffer.frameLength == 0 {
                // done
                    print("TTS conversion and saving to file is complete!")
                    DispatchQueue.main.async {
                        // UI updates or notifications can be placed here.
                       
                        self.isActive = true
                    }
            } else {
                if output == nil {
                    do {
                        output = try AVAudioFile(
                            forWriting: audioUrl,
                            settings: pcmBuffer.format.settings,
                            commonFormat: .pcmFormatInt16,
                            interleaved: false)
                    } catch {
                        print("Error creating AVAudioFile: \(error.localizedDescription)")
                    }
                }
                do {
                    try output?.write(from: pcmBuffer)
                } catch {
                    print("Error writing to AVAudioFile: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    internal func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func playAudio() {
        guard let url = audioUrl else {
            print("Audio file URL is nil.")
            return
        }
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
        
        //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription), \(error.localizedFailureReason ?? "") (Code: \(error.code))")
        }
        let path = url.absoluteString

        //Here song is the file name and .mp3 is extension of file
        print("checking path", path)

        if FileManager.default.fileExists(atPath: path) {
            print("FILE Yes AVAILABLE")
        }
        else {
        print("FILE Not AVAILABLE")
        }
    }
}

