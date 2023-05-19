//
//  SpeechRecognizer.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/12.
//

import AVFoundation
import Foundation
import Speech
import SwiftUI
import Combine



class SpeechManager : ObservableObject {
    
    public var locale = Locale.current
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    //MARK: - Methods
    /// Request authorization to use speech recognition services.
    func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    break
                default:
                    print("Speechrecognition is not available!")
                }
            }
        }
    }
    
    func startSpeechRecognition(completion: @escaping (String?) -> Void) {
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
            print("Speech recognition is not available")
            return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        /// Async method for the speech recognition request to initiate the speech recognition process on the audio contained in the request object
        recognizer.recognitionTask(with: recognitionRequest!) { result, error in
            guard error == nil else {
                print("Recognition error \(error!.localizedDescription)")
                return
            }
            guard let result = result else { return }
            /// Checks is result of recognition is final and its transcriptionn won't change
            if result.isFinal {
                /// Async execution of speech recognition result as string
                completion(result.bestTranscription.formattedString)
            }
        }
    }
}
