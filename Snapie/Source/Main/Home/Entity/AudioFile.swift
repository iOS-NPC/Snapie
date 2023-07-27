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
    var audioUrl : String
    var text : String
    var recordedAt : Date
    var totalTime : Int
    var audioTitle : String
    //let subTitle : String
}
