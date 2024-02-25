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
    
    init(name: State<String>, date: State<Date>) {
        self._name = name
        self._date = date
    }
    
    var body: some View {
        VStack {
            Text("Chapter \(name) details")
            DatePicker (
                "Date",
                selection: $date,
                displayedComponents: [.date]
            )
        }
        
    }
}

#Preview {
    ChapterDetailsScreen(name: State(initialValue: "Chapter title"), date: State(initialValue: Date()))
}
