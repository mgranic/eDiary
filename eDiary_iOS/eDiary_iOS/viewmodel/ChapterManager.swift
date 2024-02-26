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
    //= [
    //    Chapter(name: "chapter 1", date: Date()),
    //    Chapter(name: "chapter 2", date: Date()),
    //    Chapter(name: "chapter 3", date: Date()),
    //    Chapter(name: "chapter 4", date: Date()),
    //]
    
    
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
