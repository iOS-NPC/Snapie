//
//  AddDataManager.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/05.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class AddDataManager : ObservableObject {
    var firebaseManager = FirebaseManager()
    @Published var audioFiles : [AudioFile] = []
    init() {
        self.fetchAudioFiles()
    }
    func fetchAudioFiles() {
        firebaseManager.fetchAudioFiles() { (result) in
            switch result {
            case .success(let audioFiles):
                // Use the audioFiles array to update your UI
                print(audioFiles)
                self.audioFiles = audioFiles
            case .failure(let error):
                // Handle any errors
                print("Error fetching audio files: \(error)")
            }
        }
    }
}
