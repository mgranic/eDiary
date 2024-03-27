//
//  Chapter.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import Foundation
import SwiftData

@Model
class Chapter : ObservableObject {
    var id: UUID
    var userId:UUID
    var name: String
    var date: Date
    var desc: String
    // `.cascade` tells SwiftData to delete all animals contained in the
    // category when deleting it.
    @Relationship(deleteRule: .cascade, inverse: \Event.chapter)
    var events: [Event]
    
    init(id: UUID = UUID(), name: String, date: Date, description: String, events: [Event] = [Event](), userId:UUID = UUID()) {
        self.id = id
        self.name = name
        self.date = date
        self.desc = description
        self.events = events
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
