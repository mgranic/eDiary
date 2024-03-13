//
//  EventManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 06.03.2024..
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

class EventManager : ObservableObject {
    
    @Published var eventList: [Event] = []
    @Published var databaseOperationFailed = false
    
    // create Event based on the parameters and store it into the database
    func createEvent(chapterId: UUID, name: String, date: Date, description: String, img: PhotosPickerItem? = nil, modelCtx: ModelContext) async {
        // if img is not nil
        if let image = img {
            do {
                let imgData = try await image.loadTransferable(type: Data.self)
                modelCtx.insert(Event(chapterId: chapterId, name: name, description: description, date: date, img: imgData))
            } catch {
                databaseOperationFailed = true
            }
            
        } else {
            modelCtx.insert(Event(chapterId: chapterId, name: name, description: description, date: date))
        }
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
    
    // delete event with ID specified by function parameter from database
    func deleteById(dbId: UUID, modelCtx: ModelContext) {
        do {
            // delete from database
            try modelCtx.delete(model: Event.self, where: #Predicate { event in event.id == dbId })
            // delete from list view
            eventList.removeAll(where: { event in event.id == dbId})
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
        }
    }
    
    /************************************************************************************PRIVATE FUNCTIONS************************************************************************************/
    
}
