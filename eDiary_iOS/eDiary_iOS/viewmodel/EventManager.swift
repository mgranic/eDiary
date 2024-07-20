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
    
    // check if this is image created from gallery or camera and act accordingly
    func createEventDispatcher(chapterId: UUID, name: String, date: Date, description: String, imgPicker: PhotosPickerItem? = nil, imgUiImg: UIImage? = nil, modelCtx: ModelContext) async {
        
        if imgUiImg != nil {
            // create event from camera photo
            await createEvent(chapterId: chapterId, name: name, date: date, description: description, img: imgUiImg, modelCtx: modelCtx)
        } else {
            // ceate event from gallery photo (or no photo)
            await createEvent(chapterId: chapterId, name: name, date: date, description: description, img: imgPicker, modelCtx: modelCtx)
        }
        
    }
    
    // create Event based on the parameters and store it into the database (image is selected from gallery)
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
    
    // create Event based on the parameters and store it into the database (image is captured by camera directly)
    func createEvent(chapterId: UUID, name: String, date: Date, description: String, img: UIImage? = nil, modelCtx: ModelContext) async {
        // if img is not nil
        if let image = img {
            let imgData = image.pngData()
            modelCtx.insert(Event(chapterId: chapterId, name: name, description: description, date: date, img: imgData))
        } else {
            modelCtx.insert(Event(chapterId: chapterId, name: name, description: description, date: date))
        }
    }
    
    // edit event with image comminng either from gallery or from camera
    func editEventDispatcher(eventId: UUID, name: String, date: Date, description: String, imgPhotosPicker: PhotosPickerItem? = nil, imgUiImage: UIImage? = nil, modelCtx: ModelContext) async {
        
        if imgUiImage != nil {
            // edit image with photo from camera
            await editEvent(eventId: eventId, name: name, date: date, description: description, img: imgUiImage, modelCtx: modelCtx)
        } else {
            // edit image with photo from gallery (or no photo)
            await editEvent(eventId: eventId, name: name, date: date, description: description, img: imgPhotosPicker, modelCtx: modelCtx)
        }
        
    }
    
    // edit event with id = eventId (image from gallery)
    func editEvent(eventId: UUID, name: String, date: Date, description: String, img: PhotosPickerItem? = nil, modelCtx: ModelContext) async {
        let descriptor = Event.searchById(evId: eventId)
        do {
            let event = try modelCtx.fetch(descriptor)
            event.first?.name = name
            event.first?.date = date
            event.first?.desc = description
            
            // if photospickeritem is passed store it to database
            if let image = img {
                let imgData = try await image.loadTransferable(type: Data.self)
                event.first?.image = imgData
            }
            
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
        }
    }
    
    // edit event with id = eventId (image from camera)
    func editEvent(eventId: UUID, name: String, date: Date, description: String, img: UIImage? = nil, modelCtx: ModelContext) async {
        let descriptor = Event.searchById(evId: eventId)
        do {
            let event = try modelCtx.fetch(descriptor)
            event.first?.name = name
            event.first?.date = date
            event.first?.desc = description
            
            // if photospickeritem is passed store it to database
            if let image = img {
                let imgData = image.pngData()
                event.first?.image = imgData
            }
            
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
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
    
    // get event by ID
    func getEvent(eventId:UUID, modelCtx: ModelContext) -> Event? {
        let descriptor = Event.searchById(evId: eventId)
        do {
            let event = try modelCtx.fetch(descriptor)
            databaseOperationFailed = false
            return event.first!
        } catch {
            databaseOperationFailed = true
            return nil
        }
        
    }
    
    /************************************************************************************PRIVATE FUNCTIONS************************************************************************************/
    
}
