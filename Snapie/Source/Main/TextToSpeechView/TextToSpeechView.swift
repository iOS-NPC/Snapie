//
//  TranslationView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI

struct TextToSpeechView: View {
    @StateObject var viewModel = TTSManager()
    //@State private var text: String?

    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    @State var placeholderText: String = "원하시는 텍스트를 입력해주세요"
    var body: some View {
//        VStack {
//            Spacer()
//            //TextField("원하시는 텍스트를 입력해주세요", text: $text)
//            //TextEditor(text: $text)
//              //  .font(.pretendardFont(.regular, size: 14))
//             //   .foregroundColor(.greyScale2)
//
//             //   .background(Color.greyScale12)
//             //   .cornerRadius(12)
//             //   .border(Color.greyScale10)
//                //.overlay(
//               //     RoundedRectangle(cornerRadius: 12)
//               //         .stroke(Color.greyScale10, lineWidth: 1) // Set the border
//              //  )
//            ZStack {
//                if self.content.isEmpty {
//                    TextEditor(text: $placeholderText)
//                        .font(.pretendardFont(.regular, size: 14))
//                        .foregroundColor(.greyScale2)
//                        .disabled(true)
//                        .padding()
//                }
//                TextEditor(text: $content)
//                    .font(.body)
//                    .opacity(self.content.isEmpty ? 0.25 : 1)
//                    .padding()
//            }
//        }
//        .padding()
        VStack{
            if viewModel.isActive {
                Button {
                    viewModel.playAudio()
                } label: {
                    Image("play")
                }

            } 
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.play()
                } label: {
                    Text("생성하기")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.white)
                        .background(Color.primary1)
                        .cornerRadius(12)
                }

            }
            VStack {
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        Color.gray
                            .opacity(0.3)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Text(viewModel.text ?? viewModel.placeholder)
                            .padding()
                            .opacity(viewModel.text == nil ? 1 : 0)
                        TextEditor(text: Binding($viewModel.text, replacingNilWith: ""))
                            .frame(minHeight: 30, alignment: .leading)
                            .cornerRadius(6.0)
                            .multilineTextAlignment(.leading)
                            .padding(9)
                    }
                }
                .frame(maxHeight: 60)
                
            }
        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}
struct TextEditorApproachView: View {
    
    @State private var text: String?
    
    let placeholder = "Enter Text Here"
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    Color.gray
                        .opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(text ?? placeholder)
                        .padding()
                        .opacity(text == nil ? 1 : 0)
                    TextEditor(text: Binding($text, replacingNilWith: ""))
                        .frame(minHeight: 30, alignment: .leading)
                        .cornerRadius(6.0)
                        .multilineTextAlignment(.leading)
                        .padding(9)
                }
            }
        }
    }
}
struct TextToSpeechView_Previews: PreviewProvider {
    static var previews: some View {
        TextToSpeechView()
    }
}

public extension Binding where Value: Equatable {
    
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                } else {
                    source.wrappedValue = newValue
                }
            }
        )
    }
}
