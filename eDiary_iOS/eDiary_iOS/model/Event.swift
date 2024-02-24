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
    
    init(id: UUID = UUID(), chapterId: UUID, name: String, description: String, date: Date) {
        self.id = id
        self.chapterId = chapterId
        self.name = name
        self.desc = description
        self.date = date
        self.timestamp = Date()
    }
}
