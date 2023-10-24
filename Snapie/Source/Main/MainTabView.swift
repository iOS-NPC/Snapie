//
//  MainTabView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI

struct MainTabView: View {
    @State var selection = 0
    init() {
        UITabBar.appearance().backgroundColor = UIColor.grey6
       
    }
    
    var body: some View {
        
        TabView(selection: $selection) {
            HomeView().tabItem {
                if selection == 0 {
                    Image("home_on")
                } else {
                    Image("home_off")
                }
                //Text("문서")
            }.tag(0)
            TextToSpeechView().tabItem {
                if selection == 2 {
                    Image("translate_on")
                } else {
                    Image("translate_off")
                }
                //Text("")
                
            }.tag(1)
            
        }
        .accentColor(.black)
        
        
        
    }
}
extension UITabBarController {
    override open func viewDidLoad() {
        let standardAppearance = UITabBarAppearance()
        
        standardAppearance.stackedItemPositioning = .centered
        standardAppearance.stackedItemSpacing = 100
        standardAppearance.stackedItemWidth = 60

        tabBar.standardAppearance = standardAppearance
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
