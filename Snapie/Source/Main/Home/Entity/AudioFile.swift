//
//  File.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct AudioFile: Codable, Hashable {
    let audioUrl : String
    let text : String
    let recordedAt : Date
    let totalTime : Int
    let audioTitle : String
}
