//
//  AudioEngine.swift
//  Snapie
//
//  Created by 남경민 on 2023/05/13.
//

import Foundation
import Speech
import Combine

enum Language {
    static var current: String {
        return Locale.preferredLanguages[0]
    }
    static let english = "en_US"
    static let korean = "ko-KR"
}

class AudioEngine: ObservableObject {
    enum RecordingState {
        case recording
        case paused
        case stopped
    }
    
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    private var state : RecordingState = .stopped
    private var isInterrupted : Bool = false
    private var configChangePending : Bool = false
    
    public var locale = Locale.current
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    @Published var text : String = ""
    
    init() {
        checkPermissions()
        setupSession()
        setupEngine()
        
    }
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

    
    fileprivate func setupSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("[ERROR] \(#function) - \(error.localizedDescription)")
        }
    }
    fileprivate func setupEngine() {
        engine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
        
        mixerNode.volume = 0
        
        engine.attach(mixerNode)
        
        makeConnection()
        
        engine.prepare()
        
    }
    
    func makeConnection() {
        
        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        engine.connect(inputNode, to: mixerNode, format: inputFormat)
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: mixerFormat)
    }
    
    
    func startRecording(completion: @escaping (String?) -> Void) {
        
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
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let file = try! AVAudioFile(forWriting: documentURL.appendingPathComponent("recording.caf"), settings: format.settings)
        
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format) { (buffer, time) in
            try? file.write(from: buffer)
            self.recognitionRequest?.append(buffer)
            
        }
        try! engine.start()
        state = .recording
    }
    
    func resumeRecording() throws {
        try engine.start()
        state = .recording
    }
    
    func pauseRecording() {
        engine.pause()
        state = .paused
    }
    
    func stopRecording() {
        /// Marks the end of audio input for the recognition request.
        recognitionRequest?.endAudio()
        /// Deinit request
        recognitionRequest = nil
        mixerNode.removeTap(onBus: 0)
        
        engine.stop()
        state = .stopped
    }
    // 마이크에 대한 접근 제어하기
    // 인터럽션이 발생하고 끝났을 때 다시 녹음 재개 -> 예외 처리 필요
    func registerForNotification() {
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else {
                return
            }
            
            // 어떤 종류의 인터럽션이 발생했는지 확인
            let userInfo = notification.userInfo
            let interruptionTypeValue = userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt ?? 0
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue)!
            
            switch interruptionType {
            case .began:
                // 인터럽션 발생
                self.isInterrupted = true
                
                if self.state == .recording {
                    // 녹음 중지
                    self.pauseRecording()
                }
            case .ended:
                // 인터럽션 끝남
                self.isInterrupted = false
                
                try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                self.handleConfigurationChange()
                
                if self.state == .paused {
                    // 녹음 재개
                    try? self.resumeRecording()
                }
                
            @unknown default :
                break
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.AVAudioEngineConfigurationChange, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else {
                return
            }
            
            // 설정변경 대기중
            self.configChangePending = true
            
            if !self.isInterrupted {
                self.handleConfigurationChange()
            } else {
                print("defering changes")
            }
        }
    }
    
    
    fileprivate func handleConfigurationChange() {
        if configChangePending {
            // 연결 재시도
            makeConnection()
        }
        configChangePending = false
    }
    
}
