//
//  File.swift
//  Snapie
//
//  Created by 남경민 on 2023/04/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct File: Codable {
    let id : UUID
    let text : String
    let date : Float
    /*
    private enum CodingKeys: String, CodingKey {
        case nickname
        case score
    }
    init(nickname: String, score: Float) {
        self.nickname = nickname
        self.score = score
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nickname = try values.decode(String.self, forKey: .nickname)
        score = try values.decode(Float.self, forKey: .score)
    }
     */
}
