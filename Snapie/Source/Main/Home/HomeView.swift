//
//  HomeView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI
import AVFoundation
import UniformTypeIdentifiers

struct HomeView: View {
    private var foods = ["녹음1", "녹음2", "파일1", "파일2"]
    @StateObject var viewModel = AddDataManager()
    @State private var searchFood = ""
    @State var presentSheet = false
    @State var presentAudioRecord = false
    @State var isShowingDocumentPicker = false
    var permissionGranted = false

    init() {
        requestAudioPermission()
    }
    var body: some View {
        
        NavigationView {
            
            VStack() {
                List {
                    ForEach(viewModel.audioFiles, id: \.self) { audio in
                        HStack(spacing:20) {
                            
                            Image("docu")
                                .padding()
                                .background(Color.primary1)
                                .cornerRadius(8)
                                            
                            VStack(alignment: .leading,spacing:8){
                                Text("\(audio.audioTitle)")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("subTitle")
                                    .font(.system(size: 14, weight: .regular))
                            }
                            Spacer()
                            var timeAgo = timeAgoSinceDate(date: audio.recordedAt, numericDates: false)
                            Text("\(timeAgo)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.grey3)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .searchable(text: $searchFood)
                
                Spacer()
                HStack {
                    Spacer()
                    
                    Button {
                        presentSheet = true
                    } label: {
                        Image("icon_add_circle_blue")
                    }
                    .padding(30)

                        
                }

            }
            .background(.white)
            .sheet(isPresented: $presentSheet) {
                BottomSheet(presentBottomSheet: $presentSheet, presentAudioRecord: $presentAudioRecord, isShowingDocumentPicker: $isShowingDocumentPicker)
                    .presentationDetents([.medium, .large])

            }
            .navigationTitle("Snapie")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $presentAudioRecord, content: {
                RecordView(presentAudioRecord: $presentAudioRecord)
                    
            })
        }
    
        
    }
    func requestAudioPermission(){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
                if granted {
                    print("Autdio: 권한 허용")
                } else {
                    print("Audio: 권한 거부")
                }
            })
        }
    func timeAgoSinceDate(date: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now

        let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)

        if (components.year! >= 2) {
            return "\(components.year!)년 전"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1년 전"
            } else {
                return "작년"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)달 전"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1달 전"
            } else {
                return "지난 달"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)주 전"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1주 전"
            } else {
                return "지난 주"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)일 전"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1일 전"
            } else {
                return "어제"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)시간 전"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1시간 전"
            } else {
                return "한 시간 전"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)분 전"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1분 전"
            } else {
                return "방금 전"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)초 전"
        } else {
            return "지금"
        }
    }

}
struct BottomSheet: View {
    @Binding var presentBottomSheet : Bool
    @Binding var presentAudioRecord : Bool
    @Binding var isShowingDocumentPicker : Bool
    var body: some View {
        VStack(spacing: 30) {
            Text("새 파일 만들기")
                .font(.system(size: 13, weight: .semibold))
            VStack {
                Text("음성 녹음, 음성 파일 업로드로 새 문서를 만들어보세요.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.grey7)
                /*
                Text("이미지 업로드로 새 번역 이미지를 만들어보세요.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.grey7)
                 */
            }
            
            HStack(spacing: 40) {
                    VStack {
                            Image("icon_recording")
                        
                        Text("음성 녹음")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .onTapGesture {
                        //self.dismissBottomSheet.toggle()
                        self.presentBottomSheet = false
                        self.presentAudioRecord = true
                    }
                VStack {
                    Image("icon_file_upload")
                    Text("파일 업로드")
                        .font(.system(size: 13, weight: .bold))
                }
                .onTapGesture {
                    self.isShowingDocumentPicker = true
                }
                .fileImporter(
                    isPresented: $isShowingDocumentPicker,
                    allowedContentTypes: [.audio],
                    allowsMultipleSelection: false
                ) { result in
                    guard let fileURL = try? result.get().first else {
                        // 파일을 가져오지 못한 경우 또는 선택된 파일이 없는 경우 처리할 코드
                        return
                    }
                    
                    // 파일 URL을 사용하여 가져온 파일 처리
                    // 예: 음성 파일 재생, 업로드 등
                    handleFile(at: fileURL)
                }
                /*
                VStack {
                    Image("icon_image_trans")
                    Text("이미지 번역")
                        .font(.system(size: 13, weight: .bold))
                }*/
            }
                
                
        }
        
    }
    
    func handleFile(at url: URL) {
            // 파일 처리 로직을 구현
        }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
