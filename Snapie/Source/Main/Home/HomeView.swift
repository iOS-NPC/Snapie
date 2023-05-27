//
//  HomeView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    private var foods = ["Chicken Chop", "Fish n Chip", "Fried Noodle", "Fried Rice", "Bread"]
    @State private var searchFood = ""
    @State var presentSheet = false
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
                BottomSheet(presentBottomSheet: $presentSheet)
                    .presentationDetents([.medium, .large])

            }
            .navigationTitle("Snapie")
            .navigationBarTitleDisplayMode(.inline)
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
    @State var presentAudioRecord = false
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
                    .fullScreenCover(isPresented: $presentAudioRecord, content: {
                        RecordView(presentBottomSheet: $presentBottomSheet, presentAudioRecord: $presentAudioRecord)
                            
                    })
                    .onTapGesture {
                        //self.dismissBottomSheet.toggle()
                        self.presentAudioRecord.toggle()
                    }
                VStack {
                    Image("icon_file_upload")
                    Text("파일 업로드")
                        .font(.system(size: 13, weight: .bold))
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
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
