//
//  Chapter.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import Foundation
import SwiftData

@Model
class Chapter {
    var id: UUID
    var name: String
    var date: Date
    var desc: String
    var creationTimestamp: Date
    
    init(id: UUID = UUID(), name: String, date: Date, description: String) {
        self.id = id
        self.name = name
        self.date = date
        self.creationTimestamp = Date()
        self.desc = description
    }
    
    // return FetchDescriptor to filter chapter with exact ID
    static func searchById(chId: UUID) -> FetchDescriptor<Chapter> {
        let predicate =  #Predicate<Chapter> { chapter in
            chapter.id == chId
        }
        return FetchDescriptor<Chapter>(predicate: predicate)
    }
}
