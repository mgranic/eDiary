//
//  Chapter.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import Foundation
import SwiftData

@Model
class Chapter  : Codable {
    
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.name = try container.decode(String.self, forKey: .name)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.date = try container.decode(Date.self, forKey: .date)
    }
    
    // return FetchDescriptor to filter chapter with exact ID
    static func searchById(chId: UUID) -> FetchDescriptor<Chapter> {
        let predicate =  #Predicate<Chapter> { chapter in
            chapter.id == chId
        }
        return FetchDescriptor<Chapter>(predicate: predicate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(desc, forKey: .desc)
      }
}
