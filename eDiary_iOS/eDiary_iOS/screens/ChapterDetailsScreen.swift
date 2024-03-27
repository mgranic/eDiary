//
//  ChapterDetailsScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 24.02.2024..
//

import SwiftUI

struct ChapterDetailsScreen: View {
    @Environment(\.modelContext) var modelCtx
    
    @StateObject var chapter: Chapter
    
    //@State var name: String
    //@State var date: Date
    //@State var description: String
    @State var showCreateEventSheet: Bool = false   // toggle create event form
    @StateObject var eventManager: EventManager = EventManager()
    @State var showUploadAlert = false
    
    //var chapterId: UUID
    var dateFormatter: DateFormatter
    
    @State private var showEditSheet = false
    
    //init(name: State<String>, date: State<Date>, description: State<String>, chapterId: UUID) {
    //    self._name = name
    //    self._date = date
    //    self._description = description
    //    self.chapterId = chapterId
    //    self.dateFormatter = DateFormatter()
    //    self.dateFormatter.dateFormat = "E, d MMM y"
    //}
    init(chapter: StateObject<Chapter>) {
        self._chapter = chapter
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "E, d MMM y"
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text(chapter.name)
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.blue)
                Text(dateFormatter.string(from: chapter.date))
                    .font(.title3)
                Text(chapter.desc)
            }
            .frame(minWidth: UIScreen.main.bounds.width * 0.9, maxWidth: UIScreen.main.bounds.width * 0.9, minHeight: UIScreen.main.bounds.height * 0.3, maxHeight: UIScreen.main.bounds.height * 0.3)
            .background(.yellow)
            .cornerRadius(15)
            .foregroundColor(.black)
            .onTapGesture {
                showEditSheet = true
            }
            .sheet(isPresented: $showEditSheet, onDismiss: {showEditSheet = false}) {
                ChapterFormView(chapterId: chapter.id, name: $chapter.name, date: $chapter.date, description: $chapter.desc, isCreateChapter: false)
            }
            
            VStack {
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
                    eventManager.updateEventList(chapterId: chapter.id, modelCtx: modelCtx)
                }) {
                    // create event sheet
                    CreateEventView(chapter: chapter)
                }
            }
            
            VStack {
                Text("Event list")
                List {
                    // add list of events for this chapter
                    ForEach(chapter.events) { event in
                        NavigationLink(destination: EventDetailsScreen(name: State(initialValue: event.name), desc: State(initialValue: event.desc), date: State(initialValue: event.date), img:State(initialValue: event.image), id: event.id)) {
                            HStack {
                                HStack {
                                    Text(event.name)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    if let imgData = event.image {
                                        if let image = UIImage(data: imgData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }
                                }
                                
                            }
                        }
                        .frame(minWidth: UIScreen.main.bounds.width * 0.9, maxWidth: UIScreen.main.bounds.width * 0.9, minHeight: UIScreen.main.bounds.height * 0.3, maxHeight: UIScreen.main.bounds.height * 0.3)
                        .background(.gray)
                        .cornerRadius(15)
                        //.border(.blue, width: 5)
                        //.cornerRadius(20)
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                //chapterManager.deleteById(dbId: chapter.id, modelCtx: modelCtx)
                                // delete event
                                eventManager.deleteById(dbId: event.id, modelCtx: modelCtx)
                            }
                            
                        }
                    }
                }
            }
            .frame(minHeight: UIScreen.main.bounds.height * 0.5, maxHeight: UIScreen.main.bounds.height * 0.5)
        }
        .toolbar {
            Button(action: {
                // upload chapter to the server
                showUploadAlert = true
                
            }) {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .alert("Upload chapter", isPresented: $showUploadAlert) {
            Button("Yes", action: {
                /* upload selected chapter to the server */
                let uploadMgr = UploadManager(chapter: chapter, eventList: eventManager.eventList)
                uploadMgr.uploadChapter()
            })
            Button("No", role: .cancel) {
                showUploadAlert = false
            }
        } message: {
            Text("Are you sure you want to upload chapter \(chapter.name)")
        }
        .onAppear {
            // update list of events
            eventManager.updateEventList(chapterId: chapter.id, modelCtx: modelCtx)
        }
    }
}
