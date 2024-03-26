//
//  UploadManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 27.03.2024..
//

import Foundation

class UploadManager {
    var chapter: Chapter;
    var eventList: [Event]
    
    init(chapter: Chapter, eventList: [Event]) {
        self.chapter = chapter
        self.eventList = eventList
    }
    
    func uploadChapter() {
        print(chapter.name)
        
        for event in eventList {
            print(event.name)
        }
    }
}
