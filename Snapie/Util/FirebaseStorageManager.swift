//
//  FirebaseStorageManager.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/05.
//

import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    @Published var status = false
    func uploadAudioFile(url : URL?, audioTitle: String, text: String, totalTime: Int, completion: @escaping (Result<URL, Error>) -> Void) {
        print("upload audio file url : \(url) ")
        // Create the file metadata
        
        let storageRef = Storage.storage().reference().child("audioFiles/\(UUID().uuidString).m4a")
        
        if let url = url {
            /*
            storageRef.putFile(from : url, metadata: nil) { metadata, error in
                guard metadata != nil else {
                    if let error = error {
                        print("in putFile")
                        print("meta data : \(metadata)")
                        print("put file error : \(error)")
                        completion(.failure(error))
                    }
                    return
                }
                */
            let metadata = StorageMetadata()
            metadata.contentType = "audio/m4a"
            let audioData = try! Data(contentsOf: url)
            storageRef.putData(audioData,metadata: metadata) { metadata, error in
                guard metadata != nil else {
                    if let error = error {
                        print("in putFile")
                        print("meta data : \(metadata)")
                        print("put file error : \(error)")
                        completion(.failure(error))
                        self.status = false
                    }
                    return
                }
            
                storageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        if let error = error {
                            print("in download URL")
                            completion(.failure(error))
                            self.status = false
                        }
                        return
                    }
                    
                    let db = Firestore.firestore()
                    let audioFile = AudioFile(audioUrl: downloadURL.absoluteString, text: text, recordedAt: Date(), totalTime: totalTime, audioTitle: audioTitle)
                    print(audioFile)
                    let audioData = try! Firestore.Encoder().encode(audioFile)
                    db.collection("audioFiles").addDocument(data: audioData) { error in
                        if let error = error {
                            print("in add document")
                            completion(.failure(error))
                            self.status = false
                        } else {
                            completion(.success(downloadURL))
                            print("데이터 베이스 업로드 성공")
                            self.status = true
                        }
                    }
                }
            }
        }
    }
    func fetchAudioFiles(completion: @escaping (Result<[AudioFile], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("audioFiles").order(by: "recordedAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(.failure(err))
            } else {
                do {
                    var audioFiles = [AudioFile]()
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: AudioFile.self)
                        }
                        switch result {
                        case .success(let audioFile):
                            // An audioFile was successfully decoded. Add it from the list.
                            audioFiles.append(audioFile)
                        case .failure(let error):
                            print("Error decoding audioFile: \(error)")
                        }
                    }
                    completion(.success(audioFiles))
                }
            }
        }
    }
}
