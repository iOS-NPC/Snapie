//
//  HomeView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI

struct HomeView: View {
    private var foods = ["Chicken Chop", "Fish n Chip", "Fried Noodle", "Fried Rice", "Bread"]
    @State private var searchFood = ""
    @State var presentSheet = false
    var body: some View {
        NavigationStack {
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
                BottomSheet()
                    .presentationDetents([.medium, .large])

            }
            .navigationTitle("Snapie")
            .navigationBarTitleDisplayMode(.inline)
        }
    
        
    }
}
struct BottomSheet: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("새 파일 만들기")
                .font(.system(size: 13, weight: .semibold))
            VStack {
                Text("음성 녹음, 음성 파일 업로드로 새 문서를 만들어보세요.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.grey7)
                Text("이미지 업로드로 새 번역 이미지를 만들어보세요.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.grey7)
            }
            HStack(spacing: 40) {
                Image("icon_recording")
                Image("icon_file_upload")
                Image("icon_image_trans")
            }
                
                
        }
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
