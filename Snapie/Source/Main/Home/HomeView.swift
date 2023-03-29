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
    var body: some View {
        NavigationStack {
            VStack() {
                List {
                    ForEach(foods, id: \.self) { food in
                        Text(food)
                    }
                }.searchable(text: $searchFood)
            }
            .navigationTitle("Snapie")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
