//
//  eDiary_iOSApp.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 21.02.2024..
//

import SwiftUI
import SwiftData

@main
struct eDiary_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
        .modelContainer(for: [Chapter.self, Event.self])
    }
}
