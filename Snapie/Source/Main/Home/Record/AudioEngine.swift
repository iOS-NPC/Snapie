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
    
    var firebaseManager = FirebaseManager()
    @Published var speechPermission = false
    @Published var audioPermission = false
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
   var state : RecordingState = .stopped
    private var isInterrupted : Bool = false
    private var configChangePending : Bool = false
    private var audioFile: AVAudioFile?
    private var audioUrl : URL?
    
    public var locale = Locale.current
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var recognizedText : String = ""
    @Published var recordingTime = "00:00"
    @Published var title = ""
    @Published var subTitle = ""
    
    private var timer: DispatchSourceTimer?
    var secondsElapsed = 0
    
    init() {
        
    }
  
    //MARK: - Methods
    /// Request authorization to use speech recognition services.
    func requestSpeechRecogPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("speechrecognition 권한 허용")
                    self.speechPermission = true
                    break
                default:
                    print("Speechrecognition is not available!")
                }
            }
        }
    }
    func requestAudioPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .authorized:
            print("Audio: 권한 허용")
            self.audioPermission = true
        case .denied:
            print("Audio: 권한 거부")
        case .restricted,.notDetermined:
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
                if granted {
                    print("Audio: 권한 허용")
                    self.audioPermission = true
                } else {
                    print("Audio: 권한 거부")
                }
            })
        default:
            break
        }
         
    }
    

    
    func setupSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("[ERROR] \(#function) - \(error.localizedDescription)")
        }
    }
    
    func setupEngine() {
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
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: mixerFormat)
    }
    
    
    func startRecording() {
 
        
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audioUrl = documentsDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
        audioFile = try! AVAudioFile(forWriting: audioUrl!, settings: format.settings)
         
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format) { (buffer, time) in
            //try? file.write(from: buffer)
            self.recognitionRequest?.append(buffer)
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("Error writing audio file: \(error)")
            }
            
        }
        startTimer()
        try! engine.start()
        //state = .recording
    }
    
    func resumeRecording() {
        try! engine.start()
        //state = .recording
        startTimer()
    }
    
    func pauseRecording() {
        engine.pause()
        //state = .paused
        stopTimer()
    }
    
    func stopRecording() {
        /// Marks the end of audio input for the recognition request.
        recognitionRequest?.endAudio()
        /// Deinit request
        recognitionRequest = nil
        mixerNode.removeTap(onBus: 0)
        
        engine.stop()
        //state = .stopped
        stopTimer()
        
        
    }
    func uploadAudioFile() {
        print("url : \(audioUrl)")
        print("title : \(title)")
        print("text: \(recognizedText)")
        print("total time : \(secondsElapsed)")
        if title.isEmpty {
            title = "새 녹음"
        }
        firebaseManager.uploadAudioFile(url: audioUrl, audioTitle: title, text: recognizedText, totalTime: secondsElapsed) { result in
            print(result)
        }
    }
    
    private func startTimer() {
            if timer == nil {
                timer = DispatchSource.makeTimerSource(queue: .main)
                timer?.schedule(deadline: .now(), repeating: .seconds(1))
                timer?.setEventHandler { [weak self] in
                    self?.secondsElapsed += 1
                    let minute = (self?.secondsElapsed)! / 60
                    let second = (self?.secondsElapsed)! % 60
                    let minutes = String(format: "%02d", minute)
                    let seconds = String(format: "%02d", second)
                    DispatchQueue.main.async {
                        self?.recordingTime = "\(minutes):\(seconds)"
                    }
                }
            }
            timer?.resume()
        }
    private func stopTimer() {
            timer?.cancel()
            timer = nil
        if state == .stopped {
            recordingTime = "00:00"
        }
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
