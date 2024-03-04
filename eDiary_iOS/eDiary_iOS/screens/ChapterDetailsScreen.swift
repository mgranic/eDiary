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
    @State var showCreateEventSheet: Bool = false   // toggle create event form
    
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
            Button(action: {
                // show sheet to create new chapter
                showCreateEventSheet.toggle()
            }) {
                Text("Create event")
                    .font(.system(.title2, design: .rounded))
                Image(systemName: "plus.circle.fill")
            }
            .onAppear {
                // update list of events
            }
            .sheet(isPresented: $showCreateEventSheet, onDismiss: {
                // update list of events
            }) {
                // create event sheet
                CreateEventView()
            }
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
