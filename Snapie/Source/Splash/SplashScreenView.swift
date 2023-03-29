//
//  SplashScreenView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                VStack{
                    Text("Snapie")
                        .foregroundColor(.white)
                }.frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(Color.primary1)
                
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                    
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
