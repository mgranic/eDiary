//
//  CreateEventView.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 04.03.2024..
//

import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    @State var name: String = ""
    @State var date: Date = Date()
    @State var description: String = ""
    var chapterId: UUID
    
    init(chapterId: UUID) {
        self.chapterId = chapterId
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack(alignment: .center) {
                        Text("Name")
                        TextField("Name", text: $name)
                    }
                }
                Section(header: Text("Chapter description")) {
                    TextEditor(text: $description)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .navigationTitle("Description")
                        .frame(minHeight: UIScreen.main.bounds.height * 0.3, maxHeight: UIScreen.main.bounds.height * 0.3)
                }
                Section {
                    DatePicker (
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }
                Section {
                    HStack {
                        Section {
                            Button("Submit") {
                                let eventManager = EventManager()
                                eventManager.createEvent(chapterId: chapterId, name: name, date: date, description: description, modelCtx: modelCtx)
                                dismiss()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                        }
                        .disabled(self.name.isEmpty)
                        Button("Cancel") {
                            //presentSheet = false
                            dismiss()
                        }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateEventView(chapterId: UUID(uuidString: "Test uuid")!)
}
