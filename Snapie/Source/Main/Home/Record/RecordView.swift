//
//  RecordView.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/12.
//

import SwiftUI

struct RecordView: View {
    @Binding var presentBottomSheet : Bool
    @Binding var presentAudioRecord : Bool
    @StateObject var audioManager = AudioEngine()
    
    @State private var selectedLanguage = Language.korean
    @State var text = ""
    
    var body: some View {
        VStack {
            VStack {
                Text("새 파일")
                    .font(.system(size: 20, weight: .semibold))
                Text("0:00")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(.grey7)
            }
            Text(text)
   
            Spacer()
            HStack(spacing: 40) {
                VStack {
                    Image("record_complete")
                    Text("녹음 완료")
                        .font(.system(size: 13, weight: .bold))
                    
                }
                VStack {
                    Image("record_start")
                    Text("녹음 시작")
                        .font(.system(size: 13, weight: .bold))
                }.onTapGesture {
                    audioManager.locale = Locale(identifier: selectedLanguage)
                    audioManager.startRecording { speechText in
                        guard let text = speechText, !text.isEmpty else {
                            return
                        }
                        self.text = text
                    }
                }
                
                VStack {
                    Image("record_cancle")
                    Text("녹음 취소")
                        .font(.system(size: 13, weight: .bold))
                }
                .onTapGesture {
                    presentBottomSheet.toggle()
                    presentAudioRecord.toggle()
                }
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
    }
}

struct RecordView_Previews: PreviewProvider {

    static var previews: some View {
        RecordView(presentBottomSheet: .constant(true), presentAudioRecord: .constant(true))
    }
}
