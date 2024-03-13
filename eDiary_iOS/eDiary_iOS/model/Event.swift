//
//  Event.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import Foundation
import SwiftData

@Model
class Event {
    var id: UUID
    var chapterId: UUID
    var name: String
    var desc: String
    var date: Date
    var timestamp: Date
    @Attribute(.externalStorage) var image: Data?
    
    init(id: UUID = UUID(), chapterId: UUID, name: String, description: String, date: Date, img: Data? = nil) {
        self.id = id
        self.chapterId = chapterId
        self.name = name
        self.desc = description
        self.date = date
        self.timestamp = Date()
        self.image = img
    }
    
    // return FetchDescriptor to filter event with exact ID
    static func searchById(evId: UUID) -> FetchDescriptor<Event> {
        let predicate =  #Predicate<Event> { event in
            event.id == evId
        }
        return FetchDescriptor<Event>(predicate: predicate)
    }
    
    // return predicate to filter all events from database that belong to a chapter with chapterId == chId
    static func searchByChapterId(chId: UUID) -> Predicate<Event> {
        return #Predicate<Event> { event in
            event.chapterId == chId
        }
    }
    
    // return FetchDescriptior that gets all events from a specific chapter and sorts them from the latest created to oldest created
    static func serchByChapterIdSortByDateReverse(chId: UUID) -> FetchDescriptor<Event> {
        let predicate = searchByChapterId(chId: chId)
        return FetchDescriptor<Event>(predicate: predicate, sortBy: [SortDescriptor(\Event.date, order: .reverse)])
    }
}
