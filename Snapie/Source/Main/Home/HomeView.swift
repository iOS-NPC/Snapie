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
                    ForEach(foods, id: \.self) { food in
                        Text(food)
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
                    print("Camera: 권한 허용")
                } else {
                    print("Camera: 권한 거부")
                }
            })
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
