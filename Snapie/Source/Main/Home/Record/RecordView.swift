//
//  RecordView.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/12.
//

import SwiftUI

struct RecordView: View {
    @Binding var presentAudioRecord : Bool
    @StateObject var audioManager = AudioEngine()
    
    @State private var selectedLanguage = Language.korean
    @State var text = ""
    @State var title = "제목을 변경하세요."
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing:30) {
                    VStack(spacing:15) {
                        TextField("\(title)", text: $audioManager.title)
                            .font(.system(size: 28, weight: .semibold))
                            .multilineTextAlignment(.center)
                        Text("\(audioManager.recordingTime)")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(.grey7)
                    }
                    Text("\(audioManager.recognizedText)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.grey1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
   
            Spacer()
            HStack(spacing: 40) {
                VStack {
                    Image("record_complete")
                    Text("녹음 완료")
                        .font(.system(size: 13, weight: .bold))
                    
                }
                .onTapGesture {
                    audioManager.stopRecording()
                    audioManager.uploadAudioFile()
                    
                    audioManager.state = .stopped
                    //audioManager.secondsElapsed = 0
                }
                VStack {
                    switch audioManager.state {
                    case .stopped :
                        Image("record_start")
                        Text("녹음 시작")
                    case .recording :
                        Image("record_pause")
                        Text("일시 정지")
                    case .paused :
                        Image("record_start")
                        Text("계속 녹음")
                    }
                        
                }.onTapGesture {
                    
                        switch audioManager.state {
                        case .stopped :
                            Image("record_start")
                            Text("녹음 시작")
                            if audioManager.audioPermission, audioManager.speechPermission {
                                audioManager.setupSession()
                                audioManager.setupEngine()
                                
                                audioManager.locale = Locale(identifier: selectedLanguage)
                                audioManager.startRecording()
                                audioManager.state = .recording
                            }
                        case .recording :
                            audioManager.state = .paused
                            audioManager.pauseRecording()
                        case .paused :
                            audioManager.state = .recording
                            audioManager.resumeRecording()
                        }
                    }
                .font(.system(size: 13, weight: .bold))
                
                VStack {
                    Image("record_cancle")
                    Text("녹음 취소")
                        .font(.system(size: 13, weight: .bold))
                }
                .onTapGesture {
                    audioManager.stopRecording()
                    audioManager.state = .stopped
                    presentAudioRecord = false
                }
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .onAppear{
            audioManager.requestAudioPermission()
            audioManager.requestSpeechRecogPermissions()
        }
    }
}

struct RecordView_Previews: PreviewProvider {

    static var previews: some View {
        RecordView(presentAudioRecord: .constant(true))
    }
}
