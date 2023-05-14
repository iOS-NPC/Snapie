//
//  AudioEngine.swift
//  Snapie
//
//  Created by 남경민 on 2023/05/13.
//

import Foundation
import Speech
import Combine

class AudidEngine {
    // 1
    guard let fileURL = Bundle.main.url(
        forResource: "Intro",
        withExtension: "mp3")
    else {
        return
    }
    
    do {
        // 2
        let file = try AVAudioFile(forReading: fileURL)
        let format = file.processingFormat
        
        audioLengthSamples = file.length
        audioSampleRate = format.sampleRate
        audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
        
        audioFile = file
        
        // 3
        configureEngine(with: format)
    } catch {
        print("Error reading the audio file: \(error.localizedDescription)")
    }
    
    // 1
    let format = engine.mainMixerNode.outputFormat(forBus: 0)
    // 2
    

    engine.mainMixerNode.installTap(
        onBus: 0,
        bufferSize: 1024,
        format: format
    ) { buffer, _ in
        // 3
        guard let channelData = buffer.floatChannelData else {
            return
        }
        
        let channelDataValue = channelData.pointee
        // 4
        let channelDataValueArray = stride(
            from: 0,
            to: Int(buffer.frameLength),
            by: buffer.stride)
            .map { channelDataValue[$0] }
        
        // 5
        let rms = sqrt(channelDataValueArray.map {
            return $0 * $0
        }
            .reduce(0, +) / Float(buffer.frameLength))
        
        // 6
        let avgPower = 20 * log10(rms)
        // 7
        let meterLevel = self.scaledPower(power: avgPower)
        
        DispatchQueue.main.async {
            self.meterLevel = self.isPlaying ? meterLevel : 0
        }
    }
    
}
