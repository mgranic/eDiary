//
//  ChapterManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import Foundation

class ChapterManager : ObservableObject {
    @Published var chapterList: [Chapter] = [
        Chapter(name: "chapter 1", date: Date()),
        Chapter(name: "chapter 2", date: Date()),
        Chapter(name: "chapter 3", date: Date()),
        Chapter(name: "chapter 4", date: Date()),
    ]
    
    // update chapter list with the latest data from the database
    func updateChapterList() {
        
    }
}
