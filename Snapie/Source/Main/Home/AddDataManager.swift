//
//  AddDataManager.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/05.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class AddDataManager {
    private var documentListener: ListenerRegistration?
    
    func createFile(_ file: File, completion: ((Error?) -> Void)? = nil) {
        let collectionPath = "scores"
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        guard let dictionary = file.asDictionary else {
            print("decode error")
            return
        }
        collectionListener.addDocument(data: dictionary) { error in
            completion?(error)
        }
    }

    func readFile() {
        let collectionPath = "scores"
        removeListener()
        let collectionListener = Firestore.firestore().collection(collectionPath)
        var files = [File]()
 
        collectionListener.order(by: "score", descending: true).getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     
                     for document in querySnapshot!.documents {
                         print("\(document.documentID) => \(document.data())")
                         do {
                             let file = try document.data(as: File.self)
                             files.append(file)
                         } catch {
                             print("Error getting documents: \(err)")
                         }
                     }
                     //delegate.didSuccess(ranking : rankings)
                 }
                
             }
        
        
    }
    
    func removeListener() {
        documentListener?.remove()
    }
}
