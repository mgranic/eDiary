//
//  ChapterManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import Foundation
import SwiftData

class ChapterManager : ObservableObject {
    @Published var chapterList: [Chapter] = []
    @Published var databaseOperationFailed = false
    
    
    // update chapter list with the latest data from the database
    func updateChapterList(modelCtx: ModelContext) {
        let descriptor = FetchDescriptor<Chapter>(sortBy: [SortDescriptor(\Chapter.date, order: .reverse)])
        do {
            try chapterList = modelCtx.fetch(descriptor)
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
        }
    }
    
    // create Chapter based on the parameters and store it into the database
    func createChapter(name: String, date: Date, description: String, modelCtx: ModelContext) {
        modelCtx.insert(Chapter(name: name, date: date, description: description))
    }
    
    // edit chapter with id = eventId
    func editChapter(chapterId: UUID, name: String, date: Date, description: String, modelCtx: ModelContext) {
        let descriptor = Chapter.searchById(chId: chapterId)
        do {
            let chapter = try modelCtx.fetch(descriptor)
            chapter.first?.name = name
            chapter.first?.date = date
            chapter.first?.desc = description
            
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
        }
    }
    
    // delete chapter with ID specified by function parameter from database
    func deleteById(dbId: UUID, modelCtx: ModelContext) {
        do {
            // delete from database
            try modelCtx.delete(model: Chapter.self, where: #Predicate { chapter in chapter.id == dbId })
            // delete from list view
            chapterList.removeAll(where: { chapter in chapter.id == dbId})
            databaseOperationFailed = false
        } catch {
            databaseOperationFailed = true
        }
    }
}
