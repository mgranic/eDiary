//
//  ChapterDetailsScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import SwiftUI

struct ChapterDetailsScreen: View {
    @State var name: String
    @State var date: Date
    @State var description: String
    
    init(name: State<String>, date: State<Date>, description: State<String>) {
        self._name = name
        self._date = date
        self._description = description
    }
    
    var body: some View {
        VStack {
            Text("Chapter \(name) details")
            Text("Chapter description")
            Text(description)
            DatePicker (
                "Date",
                selection: $date,
                displayedComponents: [.date]
            )
        }
        
    }
}

#Preview {
    ChapterDetailsScreen(name: State(initialValue: "Chapter title"), date: State(initialValue: Date()), description: State(initialValue: "ovo je opis"))
}
