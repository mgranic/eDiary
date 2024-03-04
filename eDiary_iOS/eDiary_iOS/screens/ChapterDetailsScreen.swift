//
//  ChapterDetailsScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import SwiftUI

struct ChapterDetailsScreen: View {
    @Environment(\.modelContext) var modelCtx
    
    @State var name: String
    @State var date: Date
    @State var description: String
    @State var showCreateEventSheet: Bool = false   // toggle create event form
    @StateObject var eventManager: EventManager = EventManager()
    
    var chapterId: UUID
    
    init(name: State<String>, date: State<Date>, description: State<String>, chapterId: UUID) {
        self._name = name
        self._date = date
        self._description = description
        self.chapterId = chapterId
    }
    
    var body: some View {
        ScrollView {
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
                .sheet(isPresented: $showCreateEventSheet, onDismiss: {
                    // update list of events
                    eventManager.updateEventList(chapterId: chapterId, modelCtx: modelCtx)
                }) {
                    // create event sheet
                    CreateEventView(chapterId: chapterId)
                }
                DatePicker (
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                
                Text("Event list")
                // add list of events for this chapter
                ForEach(eventManager.eventList) { event in
                    VStack {
                        Text(event.name)
                    }
                    .frame(minHeight: UIScreen.main.bounds.height * 0.4, maxHeight: UIScreen.main.bounds.height * 0.4)
                }
            }
            .onAppear {
                // update list of events
                eventManager.updateEventList(chapterId: chapterId, modelCtx: modelCtx)
            }
        }
        
        
    }
}

#Preview {
    ChapterDetailsScreen(name: State(initialValue: "Chapter title"), date: State(initialValue: Date()), description: State(initialValue: "ovo je opis"), chapterId: UUID(uuidString: "test uuid")!)
}
