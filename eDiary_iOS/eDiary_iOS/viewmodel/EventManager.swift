//
//  EventManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 06.03.2024..
//

import Foundation
import SwiftData

class EventManager : ObservableObject {
    
    @Published var eventList: [Event] = []
    @Published var databaseOperationFailed = false
    
    // create Event based on the parameters and store it into the database
    func createEvent(chapterId: UUID, name: String, date: Date, description: String, modelCtx: ModelContext) {
        modelCtx.insert(Event(chapterId: chapterId, name: name, description: description, date: date))
    }
    
    // update event list with the latest data from the database
    func updateEventList(chapterId: UUID, modelCtx: ModelContext) {
        let descriptor = Event.serchByChapterIdSortByDateReverse(chId: chapterId)
        do {
            try eventList = modelCtx.fetch(descriptor)
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
        }
    }
}
