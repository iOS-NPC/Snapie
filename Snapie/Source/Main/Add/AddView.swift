//
//  AddView.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI

struct AddView: View {
    @State var presentSheet = false
        
        var body: some View {
            NavigationView {
                Button("Modal") {
                    presentSheet = true
                }
                .navigationTitle("Main")
            }.sheet(isPresented: $presentSheet) {
                Text("Detail")
                    .presentationDetents([.medium, .large])

            }
        }

}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
