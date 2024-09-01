//
//  Chapter.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import Foundation
import SwiftData

@Model
class Chapter  {// : Codable {
    
    enum CodingKeys: String, CodingKey {
          case id, userId, name, date, desc
    }
    
    var id: UUID
    var userId: Int?
    var name: String
    var date: Date
    var desc: String
    
    init(id: UUID = UUID(), userId: Int? = nil, name: String, date: Date, description: String) {
        self.id = id
        self.name = name
        self.date = date
        self.desc = description
        self.userId = userId
    }
    
    // return FetchDescriptor to filter chapter with exact ID
    static func searchById(chId: UUID) -> FetchDescriptor<Chapter> {
        let predicate =  #Predicate<Chapter> { chapter in
            chapter.id == chId
        }
        return FetchDescriptor<Chapter>(predicate: predicate)
    }
}
