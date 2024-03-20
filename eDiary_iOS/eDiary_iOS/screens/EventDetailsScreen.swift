//
//  EventDetailsScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 08.03.2024..
//

import SwiftUI

struct EventDetailsScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    
    @State var name: String
    @State var description: String
    @State var date: Date
    @State var img: Data?
    
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    
    var id: UUID
    var dateFormatter: DateFormatter
    
    init(name: State<String>, desc: State<String>, date: State<Date>, img: State<Data?>, id: UUID) {
        self._name = name
        self._description = desc
        self._date = date
        self._img = img
        self.id = id
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "E, d MMM y"
        
    }
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("Title \(name)")
                        
                    Text(description)
                        
                    Text(dateFormatter.string(from: date))
                }
                .onTapGesture {
                    showEditSheet = true
                }
                //DatePicker (
                //    "Date",
                //    selection: $date,
                //    displayedComponents: [.date]
                //)
                //.onChange(of: date) {
                //    showEditSheet = true
                //}
                VStack {
                    if let imgData = img {
                        if let image = UIImage(data: imgData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: UIScreen.main.bounds.width * 0.9, maxWidth: UIScreen.main.bounds.width * 0.9, minHeight: UIScreen.main.bounds.height * 0.9, maxHeight: UIScreen.main.bounds.height * 0.9)
                                .border(.blue, width: 5)
                                .cornerRadius(20)
                                
                        }
                    }
                }
                .onTapGesture {
                    showEditSheet = true
                }
            }
        }
        .toolbar {
            Button(action: {
                // delete chapter and show dialog "are you sure"
                showDeleteAlert = true
                
            }) {
                Image(systemName: "trash")
            }
        }
        .alert("Log in", isPresented: $showDeleteAlert) {
                    Button("Yes", action: submitDelete)
                    Button("No", role: .cancel) {
                        showDeleteAlert = false
                    }
                } message: {
                    Text("Are you sure you want to delete event \(name)")
        }
                .sheet(isPresented: $showEditSheet, onDismiss: {showEditSheet = false}) { // show edit event sheet
            EventFormView(eventId: id, name: $name, date: $date, description: $description, selectedImgData: $img, isCreateEvent: false)
        }
    }
    
    private func submitDelete() {
        let evManager = EventManager()
        evManager.deleteById(dbId: id, modelCtx: modelCtx)
        showDeleteAlert = false
        dismiss()
    }
}
