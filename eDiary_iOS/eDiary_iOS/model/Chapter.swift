//
//  Chapter.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import Foundation
import SwiftData

@Model
class Chapter {
    var name: String
    var date: Date
    var creationTimestamp: Date
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        self.creationTimestamp = Date()
    }
}
